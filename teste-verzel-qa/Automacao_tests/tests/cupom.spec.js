const { test, expect } = require('@playwright/test');
const { products } = require('../resources/carrinho.json');

test('Aplicar cupom de 10% e validar o valor do desconto', async ({ page }) => {
  const couponProducts = products.slice(0, 2);

  await page.goto('/');

  for (const productName of couponProducts) {
    await page
      .getByRole('article', { name: productName })
      .getByRole('button', { name: 'Adicionar ao carrinho' })
      .click();
  }

  await page.getByRole('link', { name: /Carrinho/ }).click();
  await page.getByRole('textbox').fill('BEMVINDO10');
  await page.getByRole('button', { name: 'Aplicar cupom' }).click();

  await expect(page.getByText('Cupom BEMVINDO10 aplicado.')).toBeVisible();

  const subtotalText = await page
    .locator('[data-valor="subtotal"]')
    .textContent();
  const discountText = await page
    .locator('[data-valor="desconto"]')
    .textContent();
  const subtotalCents = Number(subtotalText.replace(/\D/g, ''));
  const discountCents = Number(discountText.replace(/\D/g, ''));
  const expectedDiscountCents = Math.round(subtotalCents * 0.1);

  expect(subtotalCents).toBeGreaterThan(0);
  expect(discountCents).toBe(expectedDiscountCents);
});