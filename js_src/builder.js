const { parseDocument } = require('htmlparser2');
const CSSselect = require('css-select');
const { textContent } = require('domutils');

globalThis.parseHtml = function(html) {
    const doc = parseDocument(html);
    return {
        querySelectorAll: (selector) => CSSselect.selectAll(selector, doc).map(wrapNode),
        querySelector: (selector) => wrapNode(CSSselect.selectOne(selector, doc))
    };
};

function wrapNode(node) {
    if (!node) return null;
    const { render } = require('dom-serializer');
    return {
        text: textContent(node).trim(),
        attr: (name) => node.attribs ? node.attribs[name] : null,
        innerHTML: render(node.children || [], { decodeEntities: false }),
        querySelectorAll: (selector) => CSSselect.selectAll(selector, node).map(wrapNode),
        querySelector: (selector) => wrapNode(CSSselect.selectOne(selector, node))
    };
}
