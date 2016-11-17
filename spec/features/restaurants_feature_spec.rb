require 'rails_helper'

feature 'restaurants' do
  before do
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@testing.com')
    fill_in('Password', with: 'testing')
    fill_in('Password confirmation', with: 'testing')
    click_button('Sign up')
    click_link('Add a restaurant')
    fill_in 'Name', with: 'Momo Canteen'
    click_button 'Create Restaurant'
  end

  # context 'no restaurants have been added' do
  #   scenario 'should display a prompt to add a restaurant' do
  #     visit '/restaurants'
  #     expect(page).to have_content 'No restaurants yet'
  #     expect(page).to have_link 'Add a restaurant'
  #   end
  # end
  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'Waffle House')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('Waffle House')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

    context 'creating restaurants' do

      scenario 'prompts user to fill out a form, then displays the new restaurant' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'Waffle House'
        click_button 'Create Restaurant'
        expect(page).to have_content 'Waffle House'
        expect(current_path).to eq '/restaurants'
      end

      context 'an invalid restaurant' do
        scenario 'does not let you submit a name that is too short' do
          visit '/restaurants'
          click_link 'Add a restaurant'
          fill_in 'Name', with: 'kf'
          click_button 'Create Restaurant'
          expect(page).not_to have_css 'h2', text: 'kf'
          expect(page).to have_content 'error'
        end
      end
    end

    context 'viewing restaurants' do
      let!(:wimpy) { Restaurant.create(name: 'Wimpy') }

      scenario 'lets user view a restaurant' do
        visit '/restaurants'
        click_link 'Wimpy'
        expect(page).to have_content 'Wimpy'
        expect(current_path).to eq "/restaurants/#{wimpy.id}"
      end
    end

    context 'editing restaurants' do

      before { Restaurant.create name: 'KFC', description: 'Deep fried goodness' }

      scenario 'let a user edit a restaurant' do
        visit '/restaurants'
        click_link 'Edit KFC'
        fill_in 'Name', with: 'Kentucky Fried Chicken'
        fill_in 'Description', with: 'Deep fried goodness'
        click_button 'Update Restaurant'
        expect(page).to have_content 'Kentucky Fried Chicken'
        expect(page).to have_content 'Deep fried goodness'
        expect(current_path).to eq '/restaurants'
      end
    end

    context 'deleting restaurants' do

      before { Restaurant.create name: 'KFC', description: 'Deep fried goodness' }

      scenario 'removes a restaurant when a user clicks a delete link' do
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
        expect(page).to have_content 'Restaurant deleted successfully'
      end
    end

    context 'actions restricted to logged in users' do
      before { Restaurant.create name: 'Trade', description: 'Expensive cheese toastie' }

      scenario 'user cannot delete restaurant unless logged in' do
        click_link 'Sign out'
        click_link 'Delete Trade'
        expect(page).to have_button 'Log in'
        expect(current_path).to eq '/users/sign_in'
        expect(page).not_to have_content 'Restaurant deleted successfully'
      end
    end

    context 'user cannot delete restaurant which they haven\'t created' do
      scenario 'user can only edit/delete restaurants which they have created' do
        click_link 'Sign out'
        visit '/'
        click_link 'Sign up'
        fill_in('Email', with: 'test@example.com')
        fill_in('Password', with: 'testtest')
        fill_in('Password confirmation', with: 'testtest')
        click_button('Sign up')
        click_link('Delete Momo Canteen')
        expect(page).to have_content('Woah, woah, woah. That ain\'t your restaurant!')
      end
    end

  end
