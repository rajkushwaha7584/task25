from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import urlparse
import json
import sqlite3


ROOT_DIR = Path(__file__).resolve().parents[1]
FRONTEND_DIR = ROOT_DIR / "frontend"
DB_PATH = ROOT_DIR / "data" / "app.db"


def get_db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db():
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    with get_db() as conn:
        conn.executescript(
            """
            CREATE TABLE IF NOT EXISTS todos (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                done INTEGER NOT NULL DEFAULT 0,
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            );

            CREATE TABLE IF NOT EXISTS skills (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                level TEXT NOT NULL DEFAULT 'Beginner',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            );
            """
        )


def rows_to_dicts(rows):
    return [dict(row) for row in rows]


class AppHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(FRONTEND_DIR), **kwargs)

    def send_json(self, data, status=200):
        body = json.dumps(data).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def read_json(self):
        length = int(self.headers.get("Content-Length", "0"))
        if length == 0:
            return {}
        return json.loads(self.rfile.read(length).decode("utf-8"))

    def do_GET(self):
        path = urlparse(self.path).path
        if path == "/api/health":
            self.send_json({"status": "ok"})
            return
        if path == "/api/todos":
            with get_db() as conn:
                rows = conn.execute(
                    "SELECT id, title, done, created_at FROM todos ORDER BY id DESC"
                ).fetchall()
            self.send_json(rows_to_dicts(rows))
            return
        if path == "/api/skills":
            with get_db() as conn:
                rows = conn.execute(
                    "SELECT id, name, level, created_at FROM skills ORDER BY id DESC"
                ).fetchall()
            self.send_json(rows_to_dicts(rows))
            return
        return super().do_GET()

    def do_POST(self):
        path = urlparse(self.path).path
        data = self.read_json()

        if path == "/api/todos":
            title = str(data.get("title", "")).strip()
            if not title:
                self.send_json({"error": "Todo title is required."}, 400)
                return
            with get_db() as conn:
                cursor = conn.execute("INSERT INTO todos (title) VALUES (?)", (title,))
                row = conn.execute(
                    "SELECT id, title, done, created_at FROM todos WHERE id = ?",
                    (cursor.lastrowid,),
                ).fetchone()
            self.send_json(dict(row), 201)
            return

        if path == "/api/skills":
            name = str(data.get("name", "")).strip()
            level = str(data.get("level", "Beginner")).strip() or "Beginner"
            if not name:
                self.send_json({"error": "Skill name is required."}, 400)
                return
            with get_db() as conn:
                cursor = conn.execute(
                    "INSERT INTO skills (name, level) VALUES (?, ?)", (name, level)
                )
                row = conn.execute(
                    "SELECT id, name, level, created_at FROM skills WHERE id = ?",
                    (cursor.lastrowid,),
                ).fetchone()
            self.send_json(dict(row), 201)
            return

        self.send_json({"error": "Not found"}, 404)

    def do_PATCH(self):
        path = urlparse(self.path).path
        parts = path.strip("/").split("/")
        data = self.read_json()

        if len(parts) == 3 and parts[:2] == ["api", "todos"]:
            todo_id = parts[2]
            done = 1 if data.get("done") else 0
            with get_db() as conn:
                conn.execute("UPDATE todos SET done = ? WHERE id = ?", (done, todo_id))
                row = conn.execute(
                    "SELECT id, title, done, created_at FROM todos WHERE id = ?",
                    (todo_id,),
                ).fetchone()
            if row is None:
                self.send_json({"error": "Todo not found"}, 404)
                return
            self.send_json(dict(row))
            return

        if len(parts) == 3 and parts[:2] == ["api", "skills"]:
            skill_id = parts[2]
            level = str(data.get("level", "")).strip()
            if not level:
                self.send_json({"error": "Skill level is required."}, 400)
                return
            with get_db() as conn:
                conn.execute("UPDATE skills SET level = ? WHERE id = ?", (level, skill_id))
                row = conn.execute(
                    "SELECT id, name, level, created_at FROM skills WHERE id = ?",
                    (skill_id,),
                ).fetchone()
            if row is None:
                self.send_json({"error": "Skill not found"}, 404)
                return
            self.send_json(dict(row))
            return

        self.send_json({"error": "Not found"}, 404)

    def do_DELETE(self):
        path = urlparse(self.path).path
        parts = path.strip("/").split("/")
        if len(parts) == 3 and parts[:2] in (["api", "todos"], ["api", "skills"]):
            table = parts[1]
            item_id = parts[2]
            with get_db() as conn:
                cursor = conn.execute(f"DELETE FROM {table} WHERE id = ?", (item_id,))
            if cursor.rowcount == 0:
                self.send_json({"error": "Item not found"}, 404)
                return
            self.send_json({"deleted": True})
            return
        self.send_json({"error": "Not found"}, 404)


def main():
    init_db()
    server = ThreadingHTTPServer(("0.0.0.0", 8000), AppHandler)
    print("3-tier app running at http://0.0.0.0:8000")
    print(f"SQLite database: {DB_PATH}")
    server.serve_forever()


if __name__ == "__main__":
    main()
