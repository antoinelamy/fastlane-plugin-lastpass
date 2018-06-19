describe Fastlane::Actions::LastpassAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The lastpass plugin is working!")

      Fastlane::Actions::LastpassAction.run(nil)
    end
  end
end
