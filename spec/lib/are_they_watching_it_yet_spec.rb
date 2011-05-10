require 'init'
require 'rack/test'
require 'capybara'
require 'capybara/dsl'

describe AreTheyWatchingItOnGithubYet do
  include Rack::Test::Methods
  include Capybara

  before do
    Capybara.app = app
  end

  def app
    @app ||= AreTheyWatchingItOnGithubYet
  end

  it "should show a nice homepage" do
    visit '/'

    page.should have_content('Enter comma separated github usernames')
    page.should have_content('Enter the name of repository or user to check')
  end

  it "should show an error when Octokit raises an error" do
    Octokit.should_receive(:watchers).and_raise('Foo')
    visit '/'
    fill_in 'what', :with => 'futuresimple/jessie'
    fill_in 'who', :with => 'marcinbunsch'
    click_button 'Check it!'

    page.should have_content('Sorry! There was an error when contacting Github!')
  end

  it "should properly handle user list with whitespace" do
    Octokit.should_receive(:followers).and_return(['marcinbunsch'])
    visit '/'
    fill_in 'what', :with => 'futuresimple'
    fill_in 'who', :with => '  marcinbunsch,   futuresimple'
    click_button 'Check it!'

    page.should have_content('Is marcinbunsch following futuresimple on Github yet? YES!')
    page.should have_content('Is futuresimple following futuresimple on Github yet? NO!')
  end

  describe "repository" do

    describe "watched" do

      it "should not render when nobody is watching" do
        Octokit.should_receive(:watchers).and_return([])
        visit '/'
        fill_in 'what', :with => 'futuresimple/jessie'
        fill_in 'who', :with => 'marcinbunsch'
        click_button 'Check it!'

        page.should_not have_content('Is marcinbunsch watching futuresimple/jessie on Github yet? YES!')
      end

      it "should render properly with one user" do
        Octokit.should_receive(:watchers).and_return(['marcinbunsch'])
        visit '/'
        fill_in 'what', :with => 'futuresimple/jessie'
        fill_in 'who', :with => 'marcinbunsch'
        click_button 'Check it!'

        page.should have_content('Is marcinbunsch watching futuresimple/jessie on Github yet? YES!')
      end

      it "should render properly with many users" do
        Octokit.should_receive(:watchers).and_return(['marcinbunsch', 'futuresimple'])
        visit '/'
        fill_in 'what', :with => 'futuresimple/jessie'
        fill_in 'who', :with => 'marcinbunsch,futuresimple'
        click_button 'Check it!'

        page.should have_content('Are marcinbunsch, futuresimple watching futuresimple/jessie on Github yet? YES!')
      end

    end

    describe "not watched" do

      it "should not render when no matches are found" do
        Octokit.should_receive(:watchers).and_return(['marcinbunsch'])
        visit '/'
        fill_in 'what', :with => 'futuresimple/jessie'
        fill_in 'who', :with => 'marcinbunsch'
        click_button 'Check it!'

        page.should_not have_content('Is marcinbunsch watching futuresimple/jessie on Github yet? NO!')
      end

      it "should render properly with one user" do
        Octokit.should_receive(:watchers).and_return([])
        visit '/'
        fill_in 'what', :with => 'futuresimple/jessie'
        fill_in 'who', :with => 'marcinbunsch'
        click_button 'Check it!'

        page.should have_content('Is marcinbunsch watching futuresimple/jessie on Github yet? NO!')
      end

      it "should render properly with many users" do
        Octokit.should_receive(:watchers).and_return([])
        visit '/'
        fill_in 'what', :with => 'futuresimple/jessie'
        fill_in 'who', :with => 'marcinbunsch, futuresimple'
        click_button 'Check it!'

        page.should have_content('Are marcinbunsch, futuresimple watching futuresimple/jessie on Github yet? NO!')
      end

    end

  end

  describe "user" do

    describe "followed" do

      it "should not render when no matches are found" do
        Octokit.should_receive(:followers).and_return([])
        visit '/'
        fill_in 'what', :with => 'futuresimple'
        fill_in 'who', :with => 'marcinbunsch'
        click_button 'Check it!'

        page.should_not have_content('Is marcinbunsch following futuresimple on Github yet? YES!')
      end

      it "should render properly with one user" do
        Octokit.should_receive(:followers).and_return(['marcinbunsch'])
        visit '/'
        fill_in 'what', :with => 'futuresimple'
        fill_in 'who', :with => 'marcinbunsch'
        click_button 'Check it!'

        page.should have_content('Is marcinbunsch following futuresimple on Github yet? YES!')
      end

      it "should render properly with many users" do
        Octokit.should_receive(:followers).and_return(['marcinbunsch', 'futuresimple'])
        visit '/'
        fill_in 'what', :with => 'futuresimple'
        fill_in 'who', :with => 'marcinbunsch,futuresimple'
        click_button 'Check it!'

        page.should have_content('Are marcinbunsch, futuresimple following futuresimple on Github yet? YES!')
      end

    end

    describe "not followed" do

      it "should not render when no matches are found" do
        Octokit.should_receive(:followers).and_return(['marcinbunsch'])
        visit '/'
        fill_in 'what', :with => 'futuresimple'
        fill_in 'who', :with => 'marcinbunsch'
        click_button 'Check it!'

        page.should_not have_content('Is marcinbunsch following futuresimple on Github yet? NO!')
      end

      it "should render properly with one user" do
        Octokit.should_receive(:followers).and_return([])
        visit '/'
        fill_in 'what', :with => 'futuresimple'
        fill_in 'who', :with => 'marcinbunsch'
        click_button 'Check it!'

        page.should have_content('Is marcinbunsch following futuresimple on Github yet? NO!')
      end

      it "should render properly with many users" do
        Octokit.should_receive(:followers).and_return([])
        visit '/'
        fill_in 'what', :with => 'futuresimple'
        fill_in 'who', :with => 'marcinbunsch,futuresimple'
        click_button 'Check it!'

        page.should have_content('Are marcinbunsch, futuresimple following futuresimple on Github yet? NO!')
      end

    end

  end

end
