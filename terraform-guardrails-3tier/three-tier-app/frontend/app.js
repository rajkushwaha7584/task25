const statusEl = document.querySelector("#status");
const todoForm = document.querySelector("#todo-form");
const todoTitle = document.querySelector("#todo-title");
const todoList = document.querySelector("#todo-list");
const todoCount = document.querySelector("#todo-count");
const skillForm = document.querySelector("#skill-form");
const skillName = document.querySelector("#skill-name");
const skillLevel = document.querySelector("#skill-level");
const skillList = document.querySelector("#skill-list");
const skillCount = document.querySelector("#skill-count");

async function api(path, options = {}) {
  const response = await fetch(path, {
    headers: { "Content-Type": "application/json" },
    ...options,
  });
  const data = await response.json();
  if (!response.ok) {
    throw new Error(data.error || "Request failed");
  }
  return data;
}

function setStatus(ok) {
  statusEl.textContent = ok ? "API Online" : "API Offline";
  statusEl.className = `status ${ok ? "ok" : "fail"}`;
}

function itemDate(value) {
  return new Date(`${value}Z`).toLocaleString([], {
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

function renderTodos(todos) {
  todoCount.textContent = `${todos.length} item${todos.length === 1 ? "" : "s"}`;
  todoList.innerHTML = "";
  todos.forEach((todo) => {
    const li = document.createElement("li");
    li.className = `item ${todo.done ? "done" : ""}`;
    li.innerHTML = `
      <input type="checkbox" ${todo.done ? "checked" : ""} aria-label="Mark task done" />
      <div>
        <div class="title"></div>
        <div class="meta">Created ${itemDate(todo.created_at)}</div>
      </div>
      <button class="delete" type="button" aria-label="Delete task">x</button>
    `;
    li.querySelector(".title").textContent = todo.title;
    li.querySelector("input").addEventListener("change", async (event) => {
      await api(`/api/todos/${todo.id}`, {
        method: "PATCH",
        body: JSON.stringify({ done: event.target.checked }),
      });
      await loadAll();
    });
    li.querySelector("button").addEventListener("click", async () => {
      await api(`/api/todos/${todo.id}`, { method: "DELETE" });
      await loadAll();
    });
    todoList.appendChild(li);
  });
}

function renderSkills(skills) {
  skillCount.textContent = `${skills.length} item${skills.length === 1 ? "" : "s"}`;
  skillList.innerHTML = "";
  skills.forEach((skill) => {
    const li = document.createElement("li");
    li.className = "item";
    li.innerHTML = `
      <span class="meta">Skill</span>
      <div>
        <div class="title"></div>
        <div class="meta"></div>
      </div>
      <button class="delete" type="button" aria-label="Delete skill">x</button>
    `;
    li.querySelector(".title").textContent = skill.name;
    li.querySelector(".meta:last-child").textContent = `${skill.level} - ${itemDate(skill.created_at)}`;
    li.querySelector("button").addEventListener("click", async () => {
      await api(`/api/skills/${skill.id}`, { method: "DELETE" });
      await loadAll();
    });
    skillList.appendChild(li);
  });
}

async function loadAll() {
  const [todos, skills] = await Promise.all([api("/api/todos"), api("/api/skills")]);
  renderTodos(todos);
  renderSkills(skills);
}

todoForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  await api("/api/todos", {
    method: "POST",
    body: JSON.stringify({ title: todoTitle.value }),
  });
  todoTitle.value = "";
  await loadAll();
});

skillForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  await api("/api/skills", {
    method: "POST",
    body: JSON.stringify({ name: skillName.value, level: skillLevel.value }),
  });
  skillName.value = "";
  await loadAll();
});

async function boot() {
  try {
    await api("/api/health");
    setStatus(true);
    await loadAll();
  } catch (error) {
    console.error(error);
    setStatus(false);
  }
}

boot();
