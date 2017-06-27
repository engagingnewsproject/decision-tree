var treeJSON = {
    id: '1',
    title: 'Are You Eligible to be a US Citizen',
    startButton: 'Start',
    questions: [
            {
                id: 2,
                content: 'Are you at least 18 years old?',
                options: [
                    {
                        id: 3,
                        content: 'Yes',
                        destinationID: 2,
                    },
                    {
                        id: 3,
                        content: 'No',
                        destinationID: 4,
                    }
                ],
            },
    ]
};

// var template = Handlebars.templates['decision-tree.hbs'];
// var html = template(dtJSON);

// var DTtemplate = Handlebars.templates['DecisionTree']
// console.log(html)
var template = TreeTemplates.tree;
var html = template(treeJSON);
console.log(html);

console.log(treeJSON.id)
var treeBlock = document.getElementById('enp-tree__'+treeJSON.id);
treeBlock.innerHTML = html
