require 'spec_helper'

describe TournamentsController do
  # TODO: change to factory girl
  let(:user){User.create({:email => 'someone@someone.com',
                          :password => 'foobar'})}
  let(:another_user){User.create({:email => 'someoneelse@someone.com',
                                  :password => 'foobar'})}

  describe "GET index" do
    before do
      login_user(user)
    end

    let!(:my_tournament){
      #TODO: update this factory to have a name
      FactoryGirl.create(:tournament, :cup, {owner: user})
    }

    let!(:another_tournament){
      #TODO: update this factory to have a name
      FactoryGirl.create(:tournament, :cup, {owner: another_user})
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
    let(:tournament){FactoryGirl.create(:tournament,{owner: user})}
    let(:another_tournament){
      FactoryGirl.create(:tournament,{owner: another_user})
    }

    before do
      login_user(user)
    end

    context "user owns tournament" do
      it "renders show template" do
        get :show, id: tournament.id
        response.should render_template("show")
      end

      it "fetches tournament" do
        get :show, id: tournament.id
        assigns(:tournament).should eq(tournament)
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
    before do
      login_user(user)
    end

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

    before do
      login_user(user)
    end

    context "user owns tournament" do
      it "renders show template" do
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

      it "renders show template" do
        get :edit, id: another_tournament.id
        response.should render_template("edit")
      end

      it "fetches tournament" do
        get :edit, id: another_tournament.id
        assigns(:tournament).should eq(another_tournament)
      end
    end

    context "tournament doesn't belong to user" do
      it "doesn't render show page" do
        get :edit, id: another_tournament.id
        response.should redirect_to(tournaments_path)
      end
    end
  end


end
