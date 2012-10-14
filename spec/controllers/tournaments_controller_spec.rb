require 'spec_helper'

describe TournamentsController do
  # TODO: change to factory girl
  let(:user){User.create({:email => 'someone@someone.com',
                          :password => 'foobar'})}
  let(:another_user){User.create({:email => 'someoneelse@someone.com',
                                  :password => 'foobar'})}
  before do
    login_user(user)
  end

  describe "GET index" do
    let!(:my_tournament){
      FactoryGirl.create(:tournament, :cup, {owner: user})
    }

    let!(:another_tournament){
      FactoryGirl.create(:tournament, :cup, {owner: another_user})
    }

    let!(:closed_tournament){
      FactoryGirl.create(:tournament, :cup, :closed, {owner: user})
    }

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end

    context "user owns a tournament" do
      it "fetches tournaments that the user owns" do
        get :index
        assigns(:tournaments).should == [my_tournament]
      end

      it "fetches and closed tournaments if requested" do
        get :index , all: true
        assigns(:tournaments).should == [my_tournament, closed_tournament]
      end
    end

    context "user participates in tournaments and owns tournaments" do
      before do
        another_tournament.users << user
      end

      it "fetches participating tournaments" do
        get :index
        assigns(:tournaments).should eq([my_tournament, another_tournament])
      end
    end
  end

  describe "GET show" do
    let(:tournament){FactoryGirl.create(:tournament, :cup, {owner: user})}
    let(:another_tournament){
      FactoryGirl.create(:tournament,{owner: another_user})
    }

    context "user owns tournament" do
      it "renders show template" do
        get :show, id: tournament.id
        response.should render_template("show")
      end

      it "fetches tournament" do
        get :show, id: tournament.id
        assigns(:tournament).should eq(tournament)
      end

      context "open tournaments" do
        before do
          @round = Round.new
          @round.active = true
          @round.tournament = tournament
          @round.save!

          tournament.users << FactoryGirl.create_list(:user, 4)
          tournament.status = Tournament::OPEN
          tournament.save!

          @match1 = Match.new
          @match1.home_player_id = tournament.users.first.id
          @match1.away_player_id = tournament.users.second.id
          @match1.round = @round
          @match1.save!

          @match2 = Match.new
          @match2.home_player_id = tournament.users.third.id
          @match2.away_player_id = tournament.users.fourth.id
          @match2.round = @round
          @match2.save!
        end

        it "fetches tournament's current round" do
          get :show, id: tournament.id
          assigns(:round).should eq(@round)
        end

        it "fetches current's round matches" do
          get :show, id: tournament.id
          assigns(:matches).should eq([@match1, @match2])
        end
      end
    end

    context "user participates in tournament" do
      before do
        another_tournament.users << user
      end

      it "renders show template" do
        get :show, id: another_tournament.id
        response.should render_template("show")
      end

      it "fetches tournament" do
        get :show, id: another_tournament.id
        assigns(:tournament).should eq(another_tournament)
      end
    end

    context "tournament doesn't belong to user" do
      it "doesn't render show page" do
        get :show, id: another_tournament.id
        response.should redirect_to(tournaments_path)
      end
    end
  end

  describe "GET new" do
    it "renders the new template" do
      get :new
      response.should render_template("new")
    end

    it "initializes a new tournament" do
      get :new
      assigns(:tournament).should be_new_record
    end
  end

  describe "GET edit" do
    let(:tournament){FactoryGirl.create(:tournament,{owner: user})}
    let(:another_tournament){
      FactoryGirl.create(:tournament,{owner: another_user})
    }

    context "user owns tournament" do
      it "renders edit template" do
        get :edit, id: tournament.id
        response.should render_template("edit")
      end

      it "fetches tournament" do
        get :edit, id: tournament.id
        assigns(:tournament).should eq(tournament)
      end
    end

    context "user participates in tournament" do
      before do
        another_tournament.users << user
      end

      it "doesn't render show page" do
        get :edit, id: another_tournament.id
        response.should redirect_to(tournaments_path)
      end
    end

    context "tournament doesn't belong to user" do
      it "doesn't render show page" do
        get :edit, id: another_tournament.id
        response.should redirect_to(tournaments_path)
      end
    end
  end

  describe "POST create" do
    let(:user_params){
      {
        tournament: {
          name: 'some-name',
          game_type: Tournament::CUP,
          description: 'some description'
        }
      }
    }

    context "params create a valid tournament" do
      it "creates tournament" do
        expect {post :create, user_params}.
          to change(Tournament, :count).by(1)
      end

      it "redirects to the tournament page" do
        post :create, user_params
        response.should redirect_to(tournament_path(Tournament.last))
      end

      it "assigns the correct user id to the tournament" do
        post :create, user_params

        tournament = Tournament.last
        tournament.owner_id.should == user.id
      end

      it "assigns parameters to the tournament" do
        post :create, user_params

        tournament = Tournament.last
        tournament.name.should == 'some-name'
      end
    end

    context "params don't create a valid tournament" do
      let(:user_params){
        {
          tournament: {
            name: "",
            game_type: Tournament::CUP,
            description: 'some description'
          }
        }
      }

      it "doesn't create a tournament" do
        expect {post :create, user_params}.
          to_not change(Tournament, :count)
      end

      it "renders create page again" do
        post :create, user_params
        response.should render_template("new")
      end

      it "assigns tournament parameters" do
        post :create, user_params
        assigns(:tournament).description.should == 'some description'
      end
    end
  end

  describe "PUT update" do
    context "user is owner" do
      let(:tournament){FactoryGirl.create(:tournament, :cup, {owner: user})}
      let(:user_params){
        {
          tournament: {
            name: 'some-name',
            description: 'some description'
          },
          id: tournament.id
        }
      }

      context "params valid" do
        it "redirects to the tournament page" do
          put :update, user_params
          response.should redirect_to(tournament_path(tournament))
        end

        it "updates tournament parameters" do
          put :update, user_params
          tournament.reload.name.should == 'some-name'
        end
      end

      context "params don't create a valid tournament" do
        let(:user_params){
          {
            tournament: {
              name: "",
              description: 'some description'
            },
            id: tournament.id
          }
        }

        it "renders edit page" do
          put :update, user_params
          response.should render_template("edit")
        end
      end
    end

    context "user is participant " do
      let(:tournament){FactoryGirl.create(:tournament, :cup, {owner: another_user})}
      let(:user_params){
        {
          tournament: {
            name: 'some-name',
            description: 'some description'
          },
          id: tournament.id
        }
      }

      before do
        tournament.users << user
      end

      it "redirects to the tournament page" do
        put :update, user_params
        response.should redirect_to(tournaments_path)
      end

      it "doesn't update the tournament" do
        put :update, user_params
        tournament.reload.name.should_not == "some-name"
      end
    end

    context "user has nothing to do with the tournament" do
      let(:tournament){FactoryGirl.create(:tournament, :cup, {owner: another_user})}
      let(:user_params){
        {
          tournament: {
            name: 'some-name',
            description: 'some description'
          },
          id: tournament.id
        }
      }

      it "redirects to the tournament page" do
        put :update, user_params
        response.should redirect_to(tournaments_path)
      end

      it "doesn't update the tournament" do
        put :update, user_params
        tournament.reload.name.should_not == "some-name"
      end
    end
  end

  describe "GET register" do
    context "invalid tournament hash" do
      it "should redirect to tournaments" do
        get :register, tournament_hash: "asdfsggf"
        response.should redirect_to(tournaments_path)
      end
    end

    context "valid hash" do
      let(:tournament) { FactoryGirl.create(:tournament,
                                            :cup, { owner: another_user }) }

      it "should register" do
        get :register, tournament_hash: tournament.tournament_hash
        response.should redirect_to(tournament_path(tournament))
      end

      it "should not register if tournament is not pending" do
        tournament.status = Tournament::CLOSED
        tournament.save

        get :register, tournament_hash: tournament.tournament_hash
        response.should redirect_to(tournaments_path)
      end

      it "should not re-register if is allready in this tournament" do
        user.tournaments << tournament
        user.save

        get :register, tournament_hash: tournament.tournament_hash
        response.should redirect_to(tournaments_path)
      end
    end
  end

  describe "POST recreate_tournament_hash" do
    let(:tournament) { FactoryGirl.create(:tournament,
                                          :cup, { owner: user }) }
    let(:another_tournament) { FactoryGirl.create(:tournament,
                                                  :cup, { owner: another_user }) }

    it "should recreate tournament hash" do
      hash = tournament.tournament_hash
      post :recreate_hash, { id: tournament.id }

      tournament.reload
      tournament.tournament_hash.should_not == hash

      response.should redirect_to(tournament_path(tournament))
    end

    it "should not recreate tournament hash if is not owner" do
      hash = another_tournament.tournament_hash
      post :recreate_hash, { id: another_tournament.id }

      another_tournament.reload
      another_tournament.tournament_hash.should == hash

      response.should redirect_to(tournaments_path)
    end

    it "should not recreate tournament hash if tournament is not pending" do
      hash = tournament.tournament_hash
      tournament.status = Tournament::CLOSED
      tournament.save
      post :recreate_hash, { id: tournament.id }

      tournament.reload
      tournament.tournament_hash.should == hash

      response.should redirect_to(tournaments_path)
    end
  end

  describe "POST start" do
    context "tournament can start and logged user is owner" do
      let(:tournament){FactoryGirl.create(:tournament, :pending, :cup,{owner: user})}
      before do
        tournament.users << FactoryGirl.create_list(:user, 4)
      end

      it "starts by owner" do
        post :start, id: tournament.id
        tournament.reload.should be_open
      end

      it "redirects to tournament page" do
        post :start, id: tournament.id
        response.should redirect_to(tournament_path(tournament))
      end
    end

    context "tournament can start but logged user is not owner" do
      let(:tournament){FactoryGirl.create(:tournament,
                                          :pending, :cup,{owner: another_user})}
      before do
        tournament.users << FactoryGirl.create_list(:user, 4)
      end

      it "doesn't start by owner" do
        post :start, id: tournament.id
        tournament.reload.should be_pending
      end

      it "redirects to tournament page" do
        post :start, id: tournament.id
        response.should redirect_to(tournaments_path)
      end
    end

    context "tournament cannot start" do
      let(:tournament){FactoryGirl.create(:tournament, :pending, :cup,{owner: user})}
      it "redirects to tournament if tournament cannot start" do
        post :start, id: tournament.id
        response.should redirect_to(tournament_path(tournament))
      end

      it "doesn't open the tournament" do
        post :start, id: tournament.id
        tournament.reload.should be_pending
      end
    end
  end

  describe "POST next_round" do
    context "tournament can move to next_round and logged user is owner" do
      let(:tournament){FactoryGirl.create(:tournament, :pending, :cup,{owner: user})}
      before do
        tournament.users << FactoryGirl.create_list(:user, 4)
        tournament.start

        tournament.current_round.matches.each do |m|
          m.winner = m.home_player
          m.played = true
          m.save!
        end
      end

      it "moves next round by owner" do
        expect {post :next_round, id: tournament.id}.to change(Round, :count).by(1)
        tournament.reload.should be_open
      end

      it "redirects to tournament page" do
        post :next_round, id: tournament.id
        response.should redirect_to(tournament_path(tournament))
      end
    end

    context "tournament can go next round but logged user is not owner" do
      let(:tournament){FactoryGirl.create(:tournament,
                                          :pending, :cup,{owner: another_user})}
      before do
        tournament.users << FactoryGirl.create_list(:user, 4)
        tournament.start
      end

      it "doesn't move to next round" do
        expect {post :next_round, id: tournament.id}.to_not change(Round, :count).by(1)
      end

      it "redirects to tournament page" do
        post :next_round, id: tournament.id
        response.should redirect_to(tournaments_path)
      end
    end
  end
end
