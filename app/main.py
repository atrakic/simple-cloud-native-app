import sys

from flask import Flask, jsonify, redirect, request, url_for

data = [
    {"id": "0", "name": "google.com"},
    {"id": "1", "name": "JobZilla.com"},
    {"id": "2", "name": "Dice.com"},
    {"id": "3", "name": "LinkedIn.com"},
    {"id": "4", "name": "reed.co.uk"},
]

limit = 10

app = Flask(__name__)


@app.route("/")
def index():
    return redirect(url_for("all"))


@app.route("/api/v1/<id>", methods=["GET"])
def get(id):
    return jsonify(list(filter(lambda x: x["id"] == id, data)))


@app.route("/api/v1/add", methods=["POST"])
def add():
    req = request.get_json(force=True)
    if not any(d["id"] == req["id"] for d in data) and len(data) < limit:
        data.append({"id": req["id"], "name": req["name"]})
    return jsonify(data)


@app.route("/api/v1/all", methods=["GET"])
def all():
    return jsonify(data)


@app.route("/version")
def version():
    version = "{}.{}".format(sys.version_info.major, sys.version_info.minor)
    return jsonify(
        version=version,
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
