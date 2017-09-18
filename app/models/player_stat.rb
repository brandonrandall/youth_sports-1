class PlayerStat < ApplicationRecord
  require 'csv'
  belongs_to :player_profile
  belongs_to :game

  def stat_dates
    self.created_at.strftime('%b-%d, %Y')
  end

  def self.player_stats(player, x = 10)
    x = create_limit(x)
    PlayerStat.where(player_profile_id: player.profile.id)
    .order(created_at: :DESC)
    .limit(x)
  end

  def self.create_limit(x)
    x = 10 if x.nil?
  end

  def self.player_total_points(player)
    find_player_for_stats(player).sum(:points)

  end

  def self.player_total_fouls(player)
    find_player_for_stats(player).sum(:fouls)
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      PlayerStat.create!(player_profile_id: Player.find(row[:id]).profile.id,
                                  game_id: row[:game_id],
                                   points:  row[:points],
                                    fouls:   row[:fouls])
    end
  end

  private

  def self.find_player_for_stats(player)
    where(player_profile_id: player.profile.id)
  end
end
