import tensorflow as tf
import numpy as np

from flask import Flask, request, render_template, jsonify
from keras.models import load_model

def mse_with_positive_pressure(y_true: tf.Tensor, y_pred: tf.Tensor):
    mse = (y_true - y_pred) ** 2
    positive_pressure = 10 * tf.maximum(-y_pred, 0.0)
    return tf.reduce_mean(mse + positive_pressure)

model = load_model('note_model', custom_objects={
    'mse_with_positive_pressure': mse_with_positive_pressure
})

app = Flask(__name__)

def predict_next_note(notes, model, temperature = 1.0):
    inputs = tf.expand_dims(notes, 0)
    predictions = model.predict(inputs)

    pitch_logits = predictions['pitch']
    step = predictions['step']
    duration = predictions['duration']

    pitch_logits /= temperature
    pitch = tf.random.categorical(pitch_logits, num_samples=1)
    pitch = tf.squeeze(pitch, axis=-1)
    duration = tf.squeeze(duration, axis=-1)
    step = tf.squeeze(step, axis=-1)

    step = tf.maximum(0, step)
    duration = tf.maximum(0, duration)

    return int(pitch), float(step), float(duration)

def get_predictions(input_notes, num_predictions):
    input_notes = (input_notes[:25] / np.array([128, 1, 1]))
    generated_notes = []
    prev_start = 0

    for _ in range(num_predictions):
        pitch, step, duration = predict_next_note(input_notes, model)
        start = prev_start + step
        end = start + duration
        input_note = (pitch, step, duration)

        generated_notes.append((*input_note, start, end))
        input_notes = np.delete(input_notes, 0, axis=0)
        input_notes = np.append(input_notes, np.expand_dims(input_note, 0), axis=0)
        prev_start = start

    return generated_notes

@app.route('/predict', methods=['POST'])
def api_call():
    if request.method == 'POST':
        data = request.get_json(force=True)['data']
        # data = np.asarray(data)
        notes = get_predictions(data, 25)
        return jsonify(notes)

if __name__ == "__main__":
    app.run(debug=False, host='10.1.16.10', port=5000)