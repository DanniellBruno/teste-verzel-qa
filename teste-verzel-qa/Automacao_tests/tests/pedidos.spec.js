const { test, expect } = require('@playwright/test');
const { products } = require('../resources/carrinho.json');
const { nomeCompleto, email, cep } = require('../resources/formulario.json');



test('Finalizar pedido com frete grátis e dados válidos', async ({ page }) => {
  await page.goto('/');

  for (const productName of products) {
    await page
      .getByRole('article', { name: productName })
      .getByRole('button', { name: 'Adicionar ao carrinho' })
      .click();
  }

  await page.getByRole('link', { name: /Carrinho/ }).click();
  await expect(page.locator('[data-valor="frete"]')).toHaveText('Grátis');

  await page.getByRole('link', { name: 'Finalizar compra' }).click();
  await page.getByLabel('Nome completo').fill(nomeCompleto);
  await page.getByLabel('E-mail').fill(email);
  await page.getByLabel('CEP').fill(cep);
  await page.getByRole('button', { name: 'Confirmar pedido' }).click();

  await expect(page.getByText('Pedido confirmado', { exact: true })).toBeVisible();
  await expect(
    page.getByRole('heading', { name: /Pedido VZ-\d{6}/ })
  ).toBeVisible();

  for (const productName of products) {
    await expect(page.getByText(new RegExp(productName))).toBeVisible();
  }
});