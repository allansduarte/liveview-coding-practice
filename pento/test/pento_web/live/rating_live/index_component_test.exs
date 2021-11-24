defmodule PentoWeb.RatingLive.IndexComponentTest do
  use Pento.DataCase

  import Phoenix.LiveViewTest
  import Pento.CatalogFixtures
  import Pento.AccountsFixtures

  alias Pento.{Catalog, Survey}
  alias Pento.Accounts.User
  alias PentoWeb.RatingLive.IndexComponent

  defp rating_fixture(user, product, stars) do
    {:ok, rating} =
      Survey.create_rating(%{
        stars: stars,
        user_id: user.id,
        product_id: product.id
      })

    rating
  end

  defp create_rating(user, product, stars) do
    rating = rating_fixture(user, product, stars)
    %{rating: rating}
  end

  describe "RatingLive.IndexComponent" do
    test "renders with products" do
      product = product_fixture()
      user = user_fixture()
      create_rating(user, product, 4)

      products = Catalog.list_products_with_user_ratings(user)

      assert render_component(IndexComponent,
               products: products,
               curret_user: user
             ) =~
               "#{product.name}:\n<span class='fa fa-star checked'></span> <span class='fa fa-star checked'></span> <span class='fa fa-star checked'></span> <span class='fa fa-star checked'></span> <span class='fa fa-star'></span>\n</h4>\n\n"
    end

    test "renders with no products" do
      assert render_component(IndexComponent, products: [], curret_user: %User{}) =~
               "<h2>Ratings \n<i class='fa fa-check survey'></i>\n\n</h2>\n"
    end
  end
end
