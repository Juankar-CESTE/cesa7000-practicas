// tests/server.test.js
// Test de integración: llama a las funciones a través del servidor HTTP, como lo haría el navegador.
const server = require('../src/server');

let base;

beforeAll((done) => {
  // Puerto 0: el sistema elige uno libre, así no choca con el 3000 del servidor real
  server.listen(0, () => {
    base = `http://localhost:${server.address().port}`;
    done();
  });
});

afterAll((done) => {
  // Cierra el servidor para que Jest pueda terminar
  server.close(done);
});

test('GET /sumar devuelve el resultado', async () => {
  const res = await fetch(`${base}/sumar?a=2&b=3`);
  expect(res.status).toBe(200);
  expect(await res.json()).toEqual({ resultado: 5 });
});

test('GET /restar devuelve el resultado', async () => {
  const res = await fetch(`${base}/restar?a=5&b=3`);
  expect(res.status).toBe(200);
  expect(await res.json()).toEqual({ resultado: 2 });
});

test('GET / devuelve el mensaje por defecto', async () => {
  const res = await fetch(`${base}/`);
  expect(res.status).toBe(200);
  expect(await res.json()).toEqual({ mensaje: 'Calculadora CESA7000' });
});
