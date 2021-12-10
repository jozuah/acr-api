from fastapi import FastAPI
from src.controller.Controller import Controller
from src.model.Model import Model
from src.view.View import View

app = FastAPI()

@app.get("/")
def root():
    return "This is root"


@app.get("/text/uppercase")
def get_uppercase(source=None):
    if source:
        model = Model()
        view = View()
        controller = Controller(model, view)
        model.add_line(source)
        return {"result": controller.insert_lines()}


@app.get("/text/palindrome")
def is_palindrome(source=None):
    if source:
        return {"result": source == source[::-1]}
