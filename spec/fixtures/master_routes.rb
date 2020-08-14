module Fixtures
  MASTER_ROUTES = [
    "Rails.application.routes.draw do\n",
    "  root to: 'contacts#index'\n",
    "  resources :contacts, only: %i[index]\n",
    "  resources :csv_exports, only: %i[index create destroy]\n",
    "end\n"
  ].freeze
end
