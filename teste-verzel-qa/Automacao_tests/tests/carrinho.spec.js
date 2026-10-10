const { test, expect } = require('@playwright/test');
const { products } = require('../resources/carrinho.json');



// Adiciona produtos no carrinho e valida a quantidade de cada produto no carrinho
test('Adicionar cada produto ao carrinho sequencialmente e validar dados validos', async ({ page }) => {
  await page.goto('/');

  for (const productName of products) {
    await page
      .getByRole('article', { name: productName })
      .getByRole('button', { name: 'Adicionar ao carrinho' })
      .click();
  }

  await page.getByRole('link', { name: /Carrinho/ }).click();

  for (const productName of products) {
    await expect(
      page.getByRole('status', { name: `Quantidade de ${productName}` })
    ).toHaveText('1');
  }
});

// Adiciona todos os produtos no carrinho e remove todos os produtos do carrinho, validando que o carrinho está vazio


test('Remover todos os produtos e validar o carrinho vazio', async ({ page }) => {
  await page.goto('/');

  for (const productName of products) {
    await page
      .getByRole('article', { name: productName })
      .getByRole('button', { name: 'Adicionar ao carrinho' })
      .click();
  }

  await page.getByRole('link', { name: /Carrinho/ }).click();

  for (const productName of products) {
    await page
      .getByRole('button', { name: new RegExp(`Remover.*${productName}`, 'i') })
      .click();
  }

  await expect(
    page.getByRole('heading', { name: 'Seu carrinho está vazio' })
  ).toBeVisible();
  await expect(
    page.getByText('Escolha um produto na vitrine para começar.')
  ).toBeVisible();

  await page.getByRole('link', { name: 'Ver produtos' }).click();
  await expect(page).toHaveURL('/');
});
