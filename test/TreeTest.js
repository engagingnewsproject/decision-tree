var assert = chai.assert;
var expect = chai.expect;


// set a global var
var tree;

describe('Tree', function() {

    before(function() {
        // clear localStorage
        localStorage.clear();

        treeOptions = {
            slug: 'citizen',
            container: document.getElementById('cme-tree__citizen')
        };
        // will create var trees and add this tree to the array
        return createTree(treeOptions).then(function(newTree) {
            tree = newTree;
            let treeData = tree.getData();
            // clear localstorage for this tree
            localStorage.removeItem('treeUserID');
            localStorage.removeItem('treeHistory__'+treeData.treeID);
            localStorage.removeItem('treeHistoryIndex__'+treeData.treeID);
        });
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
            var lastQuestionID = questions[lastQuestionIndex].questionID;
            var getIndexLastQuestion = tree.getIndexBy(questions, 'questionID', lastQuestionID);

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
            var question = tree.getDataByType('question', questions[0].questionID);

            expect(questions[0].questionID)
            .to
            .equal(question.questionID);
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

    describe('setState', function() {

        it('should initialize as the state type of "intro"', function() {
            expect('intro').to.equal(tree.getState().type);
        });

        it('should initialize as the state id of the tree id', function() {
            expect(tree.getState().id).to.equal(tree.getTreeID());
        });

        it('should set the questionID to first question\'s questionID', function() {
            var questions = tree.getDataByType('question');
            var questionID = questions[0].questionID;
            tree.setState('question', questionID);

            expect(questionID).to.equal(tree.getState().id);
        });

        it('should set the state to "question"', function() {
            var questions = tree.getDataByType('question');
            var questionID = questions[0].questionID;
            tree.setState('question', questionID);

            expect('question').to.equal(tree.getState().type);
        });

        it('should set the state to "end"', function() {
            var ends = tree.getDataByType('end');
            var endID = ends[0].endID;
            tree.setState('end', endID);

            expect('end').to.equal(tree.getState().type);
        });

        it('should set the endID to first end\'s endID', function() {
            var ends = tree.getDataByType('end');
            var endID = ends[0].endID;
            tree.setState('end', endID);

            expect(endID).to.equal(tree.getState().id);
        });

        it('should set the state to "intro"', function() {
            tree.setState('intro', tree.getTreeID());

            expect('intro').to.equal(tree.getState().type);
        });

        it('should set the state id to the tree id', function() {
            tree.setState('intro', tree.getTreeID());

            expect(tree.getTreeID()).to.equal(tree.getState().id);
        });

        it('should not set the state to "foo"', function() {
            state = tree.setState('foo', 1);
            expect(state).to.equal(false);
        });

        it('should not set the state to an invalid questionID', function() {
            state = tree.setState('question', '12398019283102983102983102938102938');
            expect(state).to.equal(false);
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
            var question = tree.getQuestions(questions[0].questionID);

            expect(questions[0].questionID)
            .to
            .equal(question.questionID);
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
            var group = tree.getGroups(groups[0].groupID);

            expect(groups[0].groupID)
            .to
            .equal(group.groupID);
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
            var end = tree.getEnds(ends[0].endID);

            expect(ends[0].endID)
            .to
            .equal(end.endID);
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
            var start = tree.getStarts(starts[0].startID);

            expect(starts[0].startID)
            .to
            .equal(start.startID);
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
