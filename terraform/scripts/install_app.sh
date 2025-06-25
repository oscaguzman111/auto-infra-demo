#!/bin/bash

sudo apt update -y
sudo apt install -y python3-pip
pip3 install flask requests

mkdir -p /home/ubuntu/app/templates

cat << 'EOF' > /home/ubuntu/app/app.py
from flask import Flask, request, render_template
import requests

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    ip = requests.get("https://ifconfig.me").text
    result = None
    if request.method == "POST":
        n1 = float(request.form['n1'])
        n2 = float(request.form['n2'])
        op = request.form['op']
        if op == '+': result = n1 + n2
        elif op == '-': result = n1 - n2
        elif op == '*': result = n1 * n2
        elif op == '/': result = n1 / n2 if n2 != 0 else 'Error'
    return render_template("index.html", ip=ip, result=result)

if __name__ == "__main__":
    app.run(host='0.0.0.0')
EOF

cat << 'EOF' > /home/ubuntu/app/templates/index.html
<!DOCTYPE html>
<html>
<head><title>App EC2</title></head>
<body>
<h2>IP Pública: {{ ip }}</h2>
<form method="post">
    <input name="n1" placeholder="Número 1">
    <select name="op">
        <option>+</option><option>-</option><option>*</option><option>/</option>
    </select>
    <input name="n2" placeholder="Número 2">
    <input type="submit" value="Calcular">
</form>
{% if result is not none %}<h3>Resultado: {{ result }}</h3>{% endif %}
</body>
</html>
EOF

cd /home/ubuntu/app
nohup python3 app.py > /dev/null 2>&1 &
