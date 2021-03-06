require 'rails_helper'

RSpec.describe "Recruiter visits site and" do
  context "player is being watched by more than 3 recruiters and" do
    scenario "sees a flame icon on player profile" do
      recruiters = create_list(:recruiter, 3, :with_profile)
      players = create_list(:player, 3, :with_profile, :with_team)
      hot_players = create_list(:player, 3, :with_profile, :with_team)
      recruiters.each do |recruiter|
        hot_players.each do |player|
          create(:prospect, recruiter_profile: recruiter.profile, player_profile: player.profile)
        end
      end

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(recruiters.first)
      visit player_profile_path(hot_players.first.profile)

      expect(page).to have_css("img[src$='/assets/fire_icon-d3a8d6f5860d1b1e278ffccc2cac7b49edde9b521b365030f6704836e66c2003.jpg']")

      visit player_profile_path(hot_players[1].profile)

      expect(page).to have_css("img[src$='/assets/fire_icon-d3a8d6f5860d1b1e278ffccc2cac7b49edde9b521b365030f6704836e66c2003.jpg']")

      visit player_profile_path(hot_players.last.profile)

      expect(page).to have_css("img[src$='/assets/fire_icon-d3a8d6f5860d1b1e278ffccc2cac7b49edde9b521b365030f6704836e66c2003.jpg']")
    end

    scenario "sees a flame next to player on their prospects list on their dashboard" do
      recruiters = create_list(:recruiter, 3, :with_profile)
      players = create_list(:player, 3, :with_profile, :with_team)
      hot_players = create_list(:player, 3, :with_profile, :with_team)
      recruiters.each do |recruiter|
        hot_players.each do |player|
          create(:prospect, recruiter_profile: recruiter.profile, player_profile: player.profile)
        end
      end

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(recruiters.first)

      visit dashboard_index_path

      expect(page).to have_css("img[src$='/assets/fire_icon-d3a8d6f5860d1b1e278ffccc2cac7b49edde9b521b365030f6704836e66c2003.jpg']")
    end
  end
end
