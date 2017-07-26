var assert = chai.assert;
var expect = chai.expect;

treeOptions = {
        slug: 'citizen',
        container: document.getElementById('enp-tree__citizen')
};

var tree = new Tree(treeOptions);
describe('Tree', function() {

    before(function(done) {
        // set a quick timeout to make sure our tree is set-up before we test it
        setTimeout(function(){
              // complete the async before
              return done();
        }, 300);
    });

    after(function() {
        // runs after all tests in this block
    });

    beforeEach(function() {
        // runs before each test in this block

    });

    afterEach(function() {
        // runs after each test in this block

    });

    describe('getIndexBy', function() {

        it('should return the correct index of an object array', function() {

            var questions = tree.getDataByType('question');
            var lastQuestionIndex = questions.length - 1;
            var lastQuestionID = questions[lastQuestionIndex].question_id;
            var getIndexLastQuestion = tree.getIndexBy(questions, 'question_id', lastQuestionID);

            expect(lastQuestionIndex).to.equal(getIndexLastQuestion);
        });
    });
    // most of these are covered by questions, groups, starts,
    // and ends queries.
    // We're just doing some direct to make sure.
    describe('getDataByType', function() {

        it('should return all tree questions json', function() {
            var questions = tree.getDataByType('question');
            var type = typeof questions;
            expect(type).to.equal('object');
        });

        it('should return first question\'s json', function() {
            // get all of them so we can get the first id to make a valid call
            var questions = tree.getDataByType('question');
            // get the first one
            var question = tree.getDataByType('question', questions[0].question_id);

            expect(questions[0].question_id)
            .to
            .equal(question.question_id);
        });

        it('should return undefined when using an invalid id', function() {
            // get all of them so we can get the first id to make a valid call
            var questions = tree.getDataByType('question');
            // get the first one
            var question = tree.getDataByType('question', 123124);

            expect(question)
            .to
            .equal(undefined);
        });

        it('should only allow whitelisted names, not `foo`', function() {
            // get all of them so we can get the first id to make a valid call
            var foo = tree.getDataByType('foo');

            expect(foo)
            .to
            .equal(false);
        });

    });

    describe('getQuestions', function() {

        it('should return all tree questions json', function() {
            var questions = tree.getQuestions();

            var type = typeof questions;
            expect(type).to.equal('object');
        });

        it('should return first question\'s json', function() {
            // get all of them so we can get the first id to make a valid call
            var questions = tree.getQuestions();
            // get the first one
            var question = tree.getQuestions(questions[0].question_id);

            expect(questions[0].question_id)
            .to
            .equal(question.question_id);
        });

        it('should return undefined when using an invalid id', function() {
            // get all of them so we can get the first id to make a valid call
            var questions = tree.getQuestions();
            // get the first one
            var question = tree.getQuestions(123124);

            expect(question)
            .to
            .equal(undefined);
        });
    });

    describe('getGroups', function() {

        it('should return all tree groups json', function() {
            var groups = tree.getGroups();

            var type = typeof groups;
            expect(type).to.equal('object');
        });

        it('should return first group\'s json', function() {
            // get all of them so we can get the first id to make a valid call
            var groups = tree.getGroups();
            // get the first one
            var group = tree.getGroups(groups[0].group_id);

            expect(groups[0].group_id)
            .to
            .equal(group.group_id);
        });

        it('should return undefined when using an invalid id', function() {
            // get all of them so we can get the first id to make a valid call
            var groups = tree.getGroups();
            // get the first one
            var group = tree.getGroups(123124);

            expect(group)
            .to
            .equal(undefined);
        });
    });

    describe('getEnds', function() {

        it('should return all tree ends json', function() {
            var ends = tree.getEnds();

            var type = typeof ends;
            expect(type).to.equal('object');
        });

        it('should return first end\'s json', function() {
            // get all of them so we can get the first id to make a valid call
            var ends = tree.getEnds();
            // get the first one
            var end = tree.getEnds(ends[0].end_id);

            expect(ends[0].end_id)
            .to
            .equal(end.end_id);
        });

        it('should return undefined when using an invalid id', function() {
            // get all of them so we can get the first id to make a valid call
            var ends = tree.getEnds();
            // get the first one
            var end = tree.getEnds(123124);

            expect(end)
            .to
            .equal(undefined);
        });
    });

    describe('getStarts', function() {

        it('should return all tree starts json', function() {
            var starts = tree.getStarts();

            var type = typeof starts;
            expect(type).to.equal('object');
        });

        it('should return first start\'s json', function() {
            // get all of them so we can get the first id to make a valid call
            var starts = tree.getStarts();
            // get the first one
            var start = tree.getStarts(starts[0].start_id);

            expect(starts[0].start_id)
            .to
            .equal(start.start_id);
        });

        it('should return undefined when using an invalid id', function() {
            // get all of them so we can get the first id to make a valid call
            var starts = tree.getStarts();
            // get the first one
            var start = tree.getStarts(123124);

            expect(start)
            .to
            .equal(undefined);
        });
    });

});
