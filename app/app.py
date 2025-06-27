from flask import Flask, request, render_template
import requests

app = Flask(__name__)

@app.route('/')
def index():
    ip = requests.get("https://api.ipify.org").text
    return render_template("index.html", ip=ip)

@app.route('/calc', methods=['POST'])
def calc():
    try:
        op1 = float(request.form['op1'])
        op2 = float(request.form['op2'])
        operation = request.form['operation']
        result = eval(f"{op1} {operation} {op2}")
        return f"Resultado: {result}"
    except:
        return "Error en la operación"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
