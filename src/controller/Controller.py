class Controller:
    def __init__(self, model, view, filename=None):
        self._model = model
        self._view = view
        self._filename = filename

    def get_line(self):
        line = self._view.read()
        self._model.add_line(line)

    def insert_lines(self):
        return self._model.lines[0]
