const axios = require('axios');
const cheerio = require('cheerio');
const fs = require('fs');
const path = require('path');

// 1. Mock the Novon Environment
global.globalThis = global;

global.console = {
    log: (...args) => process.stdout.write('[JS LOG] ' + args.join(' ') + '\n'),
    error: (...args) => process.stderr.write('[JS ERROR] ' + args.join(' ') + '\n'),
    warn: (...args) => process.stdout.write('[JS WARN] ' + args.join(' ') + '\n'),
};

global.http = {
    get: async (url) => {
        console.log(`[STUB] Fetching: ${url}`);
        const response = await axios.get(url, {
            headers: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
            }
        });
        return response.data;
    }
};

// Mock __novonExtension if needed
global.__novonExtension = {};

// Mock parseHtml using cheerio
global.parseHtml = (html) => {
    const $ = cheerio.load(html);
    const wrap = (el) => {
        if (!el || el.length === 0) return null;
        return {
            text: el.text().trim(),
            attr: (name) => el.attr(name),
            querySelectorAll: (sel) => el.find(sel).map((i, e) => wrap($(e))).get(),
            querySelector: (sel) => wrap(el.find(sel).first()),
            innerHTML: el.html() || '',
            forEach: (cb) => el.each((i, e) => cb(wrap($(e))))
        };
    };
    return {
        querySelectorAll: (sel) => $(sel).map((i, e) => wrap($(e))).get(),
        querySelector: (sel) => wrap($(sel).first())
    };
};

// 2. Load the extension
const extensionPath = path.join(__dirname, '..', 'novol-test-extensions', 'com.novon.mtlarabic', 'source.js');
const source = fs.readFileSync(extensionPath, 'utf8');

try {
    // Wrap source to capture functions into global scope
    const script = `
        ${source}
        global.fetchPopular = fetchPopular;
        global.fetchLatestUpdates = fetchLatestUpdates;
        global.search = search;
        global.fetchNovelDetail = fetchNovelDetail;
        global.fetchChapterList = fetchChapterList;
        global.fetchChapterContent = fetchChapterContent;
    `;
    eval(script);
    console.log('[RUNNER] Extension script loaded and functions exported.');
} catch (e) {
    console.error('[RUNNER] Evaluation Failed:', e);
    process.exit(1);
}

// 3. Run a Test
async function runTest() {
    console.log('\n--- Starting Test: fetchLatestUpdates ---');
    try {
        // Try to find the function (either global or in __novonExtension)
        const fn = global.fetchLatestUpdates || global.__novonExtension.fetchLatestUpdates;
        
        if (typeof fn !== 'function') {
            throw new Error('fetchLatestUpdates NOT FOUND after evaluation.');
        }

        const results = await fn(1);
        console.log('\n--- Test Result ---');
        console.log(JSON.stringify(results, null, 2));
    } catch (e) {
        console.error('\n[RUNNER] Test Execution Failed:', e);
    }
}

runTest();
