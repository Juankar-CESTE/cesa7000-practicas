// tests/server.test.js
// Tests de integración (Tema 8): llaman a las funciones a través del servidor HTTP, como lo haría el navegador.
const server = require('../src/server');

let base;

beforeAll((done) => {
  // listen(0): el sistema elige un puerto libre, así no choca con el 3000 del servidor real
  server.listen(0, () => {
    base = `http://localhost:${server.address().port}`;
    done();
  });
});

afterAll((done) => {
  // Cierra las conexiones y el servidor para que Jest pueda terminar
  server.closeAllConnections();
  server.close(done);
});

describe('servidor HTTP', () => {
  test('GET /sumar devuelve el resultado', async () => {
    const res = await fetch(`${base}/sumar?a=2&b=3`);
    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({ resultado: 5 });
  });

  test('GET /restar devuelve el resultado', async () => {
    const res = await fetch(`${base}/restar?a=5&b=1`);
    expect(await res.json()).toEqual({ resultado: 4 });
  });

  test('la raíz devuelve el mensaje en JSON', async () => {
    const res = await fetch(base);
    expect(res.headers.get('content-type')).toBe('application/json');
    expect(await res.json()).toEqual({ mensaje: 'Calculadora CESA7000' });
  });
});
