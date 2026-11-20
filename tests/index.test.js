// tests/index.test.js
const { sumar, restar, multiplicar } =
  require('../src/index');
 
test('suma dos números', () => {
  expect(sumar(2, 3)).toBe(5);
});
 
test('resta dos números', () => {
  expect(restar(5, 3)).toBe(2);
});

test('multiplica dos números', () => {
  expect(multiplicar(7, 8)).toBe(56);
});