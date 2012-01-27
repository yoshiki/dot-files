// ========================== KeySnail Init File =========================== //

// この領域は, GUI により設定ファイルを生成した際にも引き継がれます
// 特殊キー, キーバインド定義, フック, ブラックリスト以外のコードは, この中に書くようにして下さい
// ========================================================================= //
//{{%PRESERVE%
key.setViewKey(':', function() {
    shell.input();
}, 'Command System');

key.setViewKey(['C-x', 's'], function () {
    shell.input('dialog pagesource ');
}, 'Open page source' );

key.setViewKey('M-u', function (ev, arg) {
    display.echoStatusBar("Copy URL to clipboard");
    command.setClipboardText(getBrowser().contentDocument.URL);
}, 'Copy URL to clipboard');

key.setGlobalKey(['C-j'], function () {
}, 'For skk', true);

key.defineKey([key.modes.VIEW, key.modes.EDIT], ['C-c', 'c'], function (ev, arg) {
    prompt.reader({
        message: "CPAN module: ",
        callback: function (query) {
            if (query) {
                let uri = 'http://search.cpan.org/search?query='
                        + encodeURIComponent(query)
                        + '&mode=module';
                openUILinkIn(uri, "tab");
            }
        },
    });
}, 'CPAN module search', true);

key.defineKey([key.modes.VIEW, key.modes.EDIT], ['C-c', 'a'], function (ev, arg) {
    prompt.reader({
        message: "ALC Search: ",
        callback: function (query) {
            if (query) {
                let uri = 'http://eow.alc.co.jp/'
                        + encodeURIComponent(query)
                        + '/UTF-8/';
                openUILinkIn(uri, "tab");
            }
        },
    });
}, 'SPECE ALC 検索', true);

key.defineKey([key.modes.VIEW, key.modes.EDIT], ['C-c', 's'], function (ev, arg) {
    let engines = util.suggest.getEngines();
    let suggestEngines = util.suggest.filterEngines(engines);
    let collection = engines.map(
        function (engine) [(engine.iconURI || {spec:""}).spec,
                           engine.name,
                           engine.description]
    );
    prompt.selector({
        message : "Select Engine:",
        collection : collection,
        flags : [ICON | IGNORE, 0, 0],
        header : ["Name", "Description"],
        keymap : {
            "s" : "prompt-decide",
            "j" : "prompt-next-completion",
            "k" : "prompt-previous-completion"
        },
        callback : function (i) {
            if (i >= 0)
                util.suggest.searchWithSuggest(engines[i],
                                               suggestEngines, "tab");
        }
    });
}, "Search With Suggest", true);

key.setViewKey('e', function (aEvent, aArg) {
    ext.exec("hok-start-foreground-mode", aArg);
}, 'Hok - Foreground hint mode', true);

key.setViewKey('E', function (aEvent, aArg) {
    ext.exec("hok-start-background-mode", aArg);
}, 'HoK - Background hint mode', true);

key.setViewKey(';', function (aEvent, aArg) {
    ext.exec("hok-start-extended-mode", aArg);
}, 'HoK - Extented hint mode', true);

key.setViewKey(['C-c', 'C-e'], function (aEvent, aArg) {
    ext.exec("hok-start-continuous-mode", aArg);
}, 'Start continuous HaH', true);

key.setGlobalKey(['C-x', 'b'], function (ev, arg) {
    ext.exec("tanything", arg);
}, "view all tabs", true);

var local = {};
plugins.options["site_local_keymap.local_keymap"] = local;
function fake(k, i) function () { key.feed(k, i); };
function pass(k, i) [k, fake(k, i)];
function ignore(k, i) [k, null];
local["^https?://reader.livedoor.com/reader/"] = [
    ['a', null],
    ['s', null],
    ['j', null],
    ['k', null],
    ['Z', null],
    ['t', function(){
         let win = content.window.wrappedJSObject;
         let item = win.get_active_item(true);
         let target = item.element;
         if (target && plugins.kungfloo)
             plugins.kungfloo.reblog(target, false, false);
    }]
];
local["^https?://mail.google.com/(mail|a)/"] = [
//    pass(['g', 'i'], 4),
//    pass(['g', 's'], 4),
//    pass(['g', 't'], 4),
//    pass(['g', 'd'], 4),
//    pass(['g', 'a'], 4),
//    pass(['g', 'c'], 4),
//    pass(['g', 'k'], 4),
    // thread list
//    pass(['*', 'a'], 4),
//    pass(['*', 'n'], 4),
//    pass(['*', 'r'], 4),
//    pass(['*', 'u'], 4),
//    pass(['*', 's'], 4),
//    pass(['*', 't'], 4),
    // navigation
    ['u', null],
    ['k', null],
    ['j', null],
    ['o', null],
    ['p', null],
    ['n', null],
    // application
    ['c', null],
    ['/', null],
    ['q', null],
    ['?', null],
    // manipulation
    ['x', null],
    ['s', null],
    ['y', null],
    ['e', null],
    ['m', null],
    ['!', null],
    ['#', null],
    ['r', null],
    ['R', null],
    ['a', null],
    ['A', null],
    ['f', null],
    ['F', null],
    ['N', null],
    pass(['<tab>', 'RET'], 4),
    ['ESC', null],
    [']', null],
    ['[', null],
    ['z', null],
    ['.', null],
    ['I', null],
    ['U', null],
    ['C-s', null],
    ['T', null]
    ['*', null],
];
//}}%PRESERVE%
// ========================================================================= //

// ========================= Special key settings ========================== //

key.quitKey              = "C-g";
key.helpKey              = "<f1>";
key.escapeKey            = "C-q";
key.macroStartKey        = "<f3>";
key.macroEndKey          = "<f4>";
key.universalArgumentKey = "C-u";
key.negativeArgument1Key = "C--";
key.negativeArgument2Key = "C-M--";
key.negativeArgument3Key = "M--";
key.suspendKey           = "<f2>";

// ================================= Hooks ================================= //

hook.setHook('KeyBoardQuit', function (aEvent) {
    if (key.currentKeySequence.length) {
        return;
    }
    command.closeFindBar();
    if (util.isCaretEnabled()) {
        command.resetMark(aEvent);
    } else {
        goDoCommand("cmd_selectNone");
    }
    key.generateKey(aEvent.originalTarget, KeyEvent.DOM_VK_ESCAPE, true);
});



// ============================= Key bindings ============================== //

key.setGlobalKey(['C-x', 'b'], function (ev, arg) {
    ext.exec("tanything", arg);
}, 'view all tabs', true);

key.setGlobalKey(['C-x', 'j'], function (aEvent, arg) {
    command.bookMarkToolBarJumpTo(aEvent, arg);
}, 'ブックマークツールバーのアイテムを開く', true);

key.setGlobalKey(['C-x', 'l'], function () {
    command.focusToById("urlbar");
}, 'ロケーションバーへフォーカス', true);

key.setGlobalKey(['C-x', 'g'], function () {
    command.focusToById("searchbar");
}, '検索バーへフォーカス', true);

key.setGlobalKey(['C-x', 't'], function () {
    command.focusElement(command.elementsRetrieverTextarea, 0);
}, '最初のインプットエリアへフォーカス', true);

key.setGlobalKey(['C-x', 's'], function () {
    command.focusElement(command.elementsRetrieverButton, 0);
}, '最初のボタンへフォーカス', true);

key.setGlobalKey(['C-x', 'k'], function (ev) {
    BrowserCloseTabOrWindow();
}, 'タブ / ウィンドウを閉じる');

key.setGlobalKey(['C-x', 'K'], function () {
    closeWindow(true);
}, 'ウィンドウを閉じる');

key.setGlobalKey(['C-x', 'n'], function (ev) {
    OpenBrowserWindow();
}, 'ウィンドウを開く');

key.setGlobalKey(['C-x', 'C-c'], function (ev) {
    goQuitApplication();
}, 'Firefox を終了', true);

key.setGlobalKey(['C-x', 'o'], function (aEvent, aArg) {
    command.focusOtherFrame(aArg);
}, '次のフレームを選択');

key.setGlobalKey(['C-x', '1'], function (aEvent) {
    window.loadURI(aEvent.target.ownerDocument.location.href);
}, '現在のフレームだけを表示', true);

key.setGlobalKey(['C-x', 'C-f'], function () {
    BrowserOpenFileWindow();
}, 'ファイルを開く', true);

key.setGlobalKey(['C-x', 'C-s'], function () {
    saveDocument(window.content.document);
}, 'ファイルを保存', true);

key.setGlobalKey([['C-M-r'], ['ESC', 'r']], function () {
    userscript.reload();
}, '設定ファイルを再読み込み', true);

key.setGlobalKey([['ESC', 'x'], ['M-x']], function (aEvent, aArg) {
    ext.select(aArg, aEvent);
}, 'エクステ', true);

key.setGlobalKey([['ESC', ':'], ['M-:']], function () {
    command.interpreter();
}, 'コマンドインタプリタ', true);

key.setGlobalKey([['ESC', 'w'], ['M-w']], function (aEvent) {
    command.copyRegion(aEvent);
}, '選択中のテキストをコピー', true);

key.setGlobalKey([['ESC', 'l'], ['C-M-l']], function () {
    getBrowser().mTabContainer.advanceSelectedTab(1, true);
}, 'ひとつ右のタブへ');

key.setGlobalKey([['ESC', 'h'], ['C-M-h']], function () {
    getBrowser().mTabContainer.advanceSelectedTab(-1, true);
}, 'ひとつ左のタブへ');

key.setGlobalKey(['ESC', 'ESC'], function (ev, arg) {
    ev.originalTarget.dispatchEvent(key.stringToKeyEvent("ESC", true));
}, 'ESC キーイベントを投げる');

key.setGlobalKey(['<f1>', 'b'], function () {
    key.listKeyBindings();
}, 'キーバインド一覧を表示');

key.setGlobalKey(['<f1>', 'F'], function (ev) {
    openHelpLink("firefox-help");
}, 'Firefox のヘルプを表示');

key.setGlobalKey('C-m', function (aEvent) {
    key.generateKey(aEvent.originalTarget, KeyEvent.DOM_VK_RETURN, true);
}, 'リターンコードを生成');

key.setGlobalKey('C-s', function (ev) {
    command.iSearchForwardKs(ev);
}, 'Emacs ライクなインクリメンタル検索', true);

key.setGlobalKey('C-r', function (ev) {
    command.iSearchBackwardKs(ev);
}, 'Emacs ライクな逆方向インクリメンタル検索', true);

key.setGlobalKey(['C-c', 'u'], function (ev) {
    undoCloseTab();
}, '閉じたタブを元に戻す');

key.setGlobalKey(['C-c', 'C-c', 'C-v'], function () {
    toJavaScriptConsole();
}, 'Javascript コンソールを表示', true);

key.setGlobalKey(['C-c', 'C-c', 'C-c'], function () {
    command.clearConsole();
}, 'Javascript コンソールの表示をクリア', true);

key.setViewKey('a', function (ev, arg) {
    ext.exec("kungfloo-reblog", arg, ev);
}, 'kungfloo - Reblog', true);

key.setViewKey(['C-c', 'c'], function (ev, arg) {
    prompt.reader({message: "CPAN module: ", callback: function (query) {if (query) {let uri = "http://search.cpan.org/search?query=" + encodeURIComponent(query) + "&mode=module";openUILinkIn(uri, "tab");}}});
}, 'CPAN module search', true);

key.setViewKey(['C-c', 'a'], function (ev, arg) {
    prompt.reader({message: "ALC Search: ", callback: function (query) {if (query) {let uri = "http://eow.alc.co.jp/" + encodeURIComponent(query) + "/UTF-8/";openUILinkIn(uri, "tab");}}});
}, 'SPECE ALC 検索', true);

key.setViewKey(['C-c', 's'], function (ev, arg) {
    var engines = util.suggest.getEngines();
    var suggestEngines = util.suggest.filterEngines(engines);
    var collection = engines.map((function (engine) [(engine.iconURI || {spec: ""}).spec, engine.name, engine.description]));
    prompt.selector({message: "Select Engine:", collection: collection, flags: [ICON | IGNORE, 0, 0], header: ["Name", "Description"], keymap: {s: "prompt-decide", j: "prompt-next-completion", k: "prompt-previous-completion"}, callback: function (i) {if (i >= 0) {util.suggest.searchWithSuggest(engines[i], suggestEngines, "tab");}}});
}, 'Search With Suggest', true);

key.setViewKey(['C-c', 'C-e'], function (aEvent, aArg) {
    ext.exec("hok-start-continuous-mode", aArg);
}, 'Start continuous HaH', true);

key.setViewKey('e', function (aEvent, aArg) {
    ext.exec("hok-start-foreground-mode", aArg);
}, 'Hok - Foreground hint mode', true);

key.setViewKey('E', function (aEvent, aArg) {
    ext.exec("hok-start-background-mode", aArg);
}, 'HoK - Background hint mode', true);

key.setViewKey(';', function (aEvent, aArg) {
    ext.exec("hok-start-extended-mode", aArg);
}, 'HoK - Extented hint mode', true);

key.setViewKey(['C-x', 'b'], function (ev, arg) {
    ext.exec("tanything", arg);
}, 'view all tabs', true);

key.setViewKey(['C-x', 'h'], function () {
    goDoCommand("cmd_selectAll");
}, 'すべて選択', true);

key.setViewKey([['C-n'], ['j']], function (aEvent) {
    key.generateKey(aEvent.originalTarget, KeyEvent.DOM_VK_DOWN, true);
}, '一行スクロールダウン');

key.setViewKey([['C-p'], ['k']], function (aEvent) {
    key.generateKey(aEvent.originalTarget, KeyEvent.DOM_VK_UP, true);
}, '一行スクロールアップ');

key.setViewKey([['C-f'], ['.']], function (aEvent) {
    key.generateKey(aEvent.originalTarget, KeyEvent.DOM_VK_LEFT, true);
}, '左へスクロール');

key.setViewKey([['C-b'], [',']], function (aEvent) {
    key.generateKey(aEvent.originalTarget, KeyEvent.DOM_VK_RIGHT, true);
}, '右へスクロール');

key.setViewKey([['M-v'], ['b'], ['ESC', 'v']], function () {
    goDoCommand("cmd_scrollPageUp");
}, '一画面分スクロールアップ');

key.setViewKey([['ESC', '<'], ['M-<'], ['g']], function () {
    goDoCommand("cmd_scrollTop");
}, 'ページ先頭へ移動', true);

key.setViewKey([['ESC', '>'], ['M->'], ['G']], function () {
    goDoCommand("cmd_scrollBottom");
}, 'ページ末尾へ移動', true);

key.setViewKey([['ESC', 'p'], ['M-p']], function () {
    command.walkInputElement(command.elementsRetrieverButton, true, true);
}, '次のボタンへフォーカスを当てる');

key.setViewKey([['ESC', 'n'], ['M-n']], function () {
    command.walkInputElement(command.elementsRetrieverButton, false, true);
}, '前のボタンへフォーカスを当てる');

key.setViewKey(['ESC', 'ESC'], function (ev, arg) {
    ev.originalTarget.dispatchEvent(key.stringToKeyEvent("ESC", true));
}, 'ESC キーイベントを投げる');

key.setViewKey('C-v', function () {
    goDoCommand("cmd_scrollPageDown");
}, '一画面スクロールダウン');

key.setViewKey('l', function () {
    getBrowser().mTabContainer.advanceSelectedTab(1, true);
}, 'ひとつ右のタブへ');

key.setViewKey('h', function () {
    getBrowser().mTabContainer.advanceSelectedTab(-1, true);
}, 'ひとつ左のタブへ');

key.setViewKey('R', function () {
    BrowserReload();
}, '更新', true);

key.setViewKey('B', function () {
    BrowserBack();
}, '戻る');

key.setViewKey('F', function () {
    BrowserForward();
}, '進む');

key.setViewKey('f', function () {
    command.focusElement(command.elementsRetrieverTextarea, 0);
}, '最初のインプットエリアへフォーカス', true);

key.setEditKey(['C-c', 'c'], function (ev, arg) {
    prompt.reader({message: "CPAN module: ", callback: function (query) {if (query) {let uri = "http://search.cpan.org/search?query=" + encodeURIComponent(query) + "&mode=module";openUILinkIn(uri, "tab");}}});
}, 'CPAN module search', true);

key.setEditKey(['C-c', 'a'], function (ev, arg) {
    prompt.reader({message: "ALC Search: ", callback: function (query) {if (query) {let uri = "http://eow.alc.co.jp/" + encodeURIComponent(query) + "/UTF-8/";openUILinkIn(uri, "tab");}}});
}, 'SPECE ALC 検索', true);

key.setEditKey(['C-c', 's'], function (ev, arg) {
    var engines = util.suggest.getEngines();
    var suggestEngines = util.suggest.filterEngines(engines);
    var collection = engines.map((function (engine) [(engine.iconURI || {spec: ""}).spec, engine.name, engine.description]));
    prompt.selector({message: "Select Engine:", collection: collection, flags: [ICON | IGNORE, 0, 0], header: ["Name", "Description"], keymap: {s: "prompt-decide", j: "prompt-next-completion", k: "prompt-previous-completion"}, callback: function (i) {if (i >= 0) {util.suggest.searchWithSuggest(engines[i], suggestEngines, "tab");}}});
}, 'Search With Suggest', true);

key.setEditKey(['C-x', 'h'], function (aEvent) {
    command.selectAll(aEvent);
}, '全て選択', true);

key.setEditKey([['C-x', 'u'], ['C-_']], function () {
    display.echoStatusBar("Undo!", 2000);
    goDoCommand("cmd_undo");
}, 'アンドゥ');

key.setEditKey(['C-x', 'r', 'd'], function (aEvent, aArg) {
    command.replaceRectangle(aEvent.originalTarget, "", false, !aArg);
}, '矩形削除', true);

key.setEditKey(['C-x', 'r', 't'], function (aEvent) {
    prompt.read("String rectangle: ", function (aStr, aInput) {command.replaceRectangle(aInput, aStr);}, aEvent.originalTarget);
}, '矩形置換', true);

key.setEditKey(['C-x', 'r', 'o'], function (aEvent) {
    command.openRectangle(aEvent.originalTarget);
}, '矩形行空け', true);

key.setEditKey(['C-x', 'r', 'k'], function (aEvent, aArg) {
    command.kill.buffer = command.killRectangle(aEvent.originalTarget, !aArg);
}, '矩形キル', true);

key.setEditKey(['C-x', 'r', 'y'], function (aEvent) {
    command.yankRectangle(aEvent.originalTarget, command.kill.buffer);
}, '矩形ヤンク', true);

key.setEditKey([['C-SPC'], ['C-@']], function (aEvent) {
    command.setMark(aEvent);
}, 'マークをセット', true);

key.setEditKey('C-o', function (aEvent) {
    command.openLine(aEvent);
}, '行を開く (Open line)');

key.setEditKey('C-\\', function () {
    display.echoStatusBar("Redo!", 2000);
    goDoCommand("cmd_redo");
}, 'リドゥ');

key.setEditKey('C-a', function (aEvent) {
    command.beginLine(aEvent);
}, '行頭へ移動');

key.setEditKey('C-e', function (aEvent) {
    command.endLine(aEvent);
}, '行末へ');

key.setEditKey('C-f', function (aEvent) {
    command.nextChar(aEvent);
}, '一文字右へ移動');

key.setEditKey('C-b', function (aEvent) {
    command.previousChar(aEvent);
}, '一文字左へ移動');

key.setEditKey([['M-f'], ['ESC', 'f']], function (aEvent) {
    command.forwardWord(aEvent);
}, '一単語右へ移動');

key.setEditKey([['ESC', 'b'], ['M-b']], function (aEvent) {
    command.backwardWord(aEvent);
}, '一単語左へ移動');

key.setEditKey([['ESC', 'v'], ['M-v']], function (aEvent) {
    command.pageUp(aEvent);
}, '一画面分上へ');

key.setEditKey([['ESC', '<'], ['M-<']], function (aEvent) {
    command.moveTop(aEvent);
}, 'テキストエリア先頭へ');

key.setEditKey([['ESC', '>'], ['M->']], function (aEvent) {
    command.moveBottom(aEvent);
}, 'テキストエリア末尾へ');

key.setEditKey([['ESC', 'd'], ['M-d']], function () {
    command.deleteForwardWord(ev);
}, '次の一単語を削除');

key.setEditKey([['ESC', '<delete>'], ['C-<backspace>'], ['M-<delete>']], function (ev) {
    command.deleteBackwardWord(ev);
}, '前の一単語を削除');

key.setEditKey([['ESC', 'u'], ['M-u']], function (ev, arg) {
    command.wordCommand(ev, arg, command.upcaseForwardWord, command.upcaseBackwardWord);
}, '次の一単語を全て大文字に (Upper case)');

key.setEditKey([['ESC', 'l'], ['M-l']], function (ev, arg) {
    command.wordCommand(ev, arg, command.downcaseForwardWord, command.downcaseBackwardWord);
}, '次の一単語を全て小文字に (Lower case)');

key.setEditKey([['ESC', 'c'], ['M-c']], function (ev, arg) {
    command.wordCommand(ev, arg, command.capitalizeForwardWord, command.capitalizeBackwardWord);
}, '次の一単語をキャピタライズ');

key.setEditKey([['ESC', 'y'], ['C-M-y']], function (aEvent) {
    if (!command.kill.ring.length) {
        return;
    }
    let (ct = command.getClipboardText()) (!command.kill.ring.length || ct != command.kill.ring[0]) &&
        command.pushKillRing(ct);
    prompt.selector({message: "Paste:", collection: command.kill.ring, callback: function (i) {if (i >= 0) {key.insertText(command.kill.ring[i]);}}});
}, '以前にコピーしたテキスト一覧から選択して貼り付け', true);

key.setEditKey([['ESC', 'n'], ['M-n']], function () {
    command.walkInputElement(command.elementsRetrieverTextarea, true, true);
}, '次のテキストエリアへフォーカス');

key.setEditKey([['ESC', 'p'], ['M-p']], function () {
    command.walkInputElement(command.elementsRetrieverTextarea, false, true);
}, '前のテキストエリアへフォーカス');

key.setEditKey(['ESC', 'ESC'], function (ev, arg) {
    ev.originalTarget.dispatchEvent(key.stringToKeyEvent("ESC", true));
}, 'ESC キーイベントを投げる');

key.setEditKey('C-n', function (aEvent) {
    command.nextLine(aEvent);
}, '一行下へ');

key.setEditKey('C-p', function (aEvent) {
    command.previousLine(aEvent);
}, '一行上へ');

key.setEditKey('C-v', function (aEvent) {
    command.pageDown(aEvent);
}, '一画面分下へ');

key.setEditKey('C-d', function () {
    goDoCommand("cmd_deleteCharForward");
}, '次の一文字削除');

key.setEditKey('C-h', function () {
    goDoCommand("cmd_deleteCharBackward");
}, '前の一文字を削除');

key.setEditKey('C-k', function (aEvent) {
    command.killLine(aEvent);
}, 'カーソルから先を一行カット (Kill line)');

key.setEditKey('C-y', command.yank, '貼り付け (Yank)');

key.setEditKey('M-y', command.yankPop, '古いクリップボードの中身を順に貼り付け (Yank pop)', true);

key.setEditKey('C-w', function (aEvent) {
    goDoCommand("cmd_copy");
    goDoCommand("cmd_delete");
    command.resetMark(aEvent);
}, '選択中のテキストを切り取り (Kill region)', true);

key.setCaretKey([['C-a'], ['^']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectBeginLine") : goDoCommand("cmd_beginLine");
}, 'キャレットを行頭へ移動');

key.setCaretKey([['C-e'], ['$'], ['M->'], ['G'], ['ESC', '>']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectEndLine") : goDoCommand("cmd_endLine");
}, 'キャレットを行末へ移動');

key.setCaretKey([['ESC', 'f'], ['M-f'], ['w']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectWordNext") : goDoCommand("cmd_wordNext");
}, 'キャレットを一単語右へ移動');

key.setCaretKey([['ESC', 'b'], ['M-b'], ['W']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectWordPrevious") : goDoCommand("cmd_wordPrevious");
}, 'キャレットを一単語左へ移動');

key.setCaretKey([['ESC', 'v'], ['M-v'], ['b']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectPagePrevious") : goDoCommand("cmd_movePageUp");
}, 'キャレットを一画面分上へ');

key.setCaretKey([['ESC', '<'], ['M-<'], ['g']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectTop") : goDoCommand("cmd_scrollTop");
}, 'キャレットをページ先頭へ移動');

key.setCaretKey([['ESC', 'p'], ['M-p']], function () {
    command.walkInputElement(command.elementsRetrieverButton, true, true);
}, '次のボタンへフォーカスを当てる');

key.setCaretKey([['ESC', 'n'], ['M-n']], function () {
    command.walkInputElement(command.elementsRetrieverButton, false, true);
}, '前のボタンへフォーカスを当てる');

key.setCaretKey(['ESC', 'ESC'], function (ev, arg) {
    ev.originalTarget.dispatchEvent(key.stringToKeyEvent("ESC", true));
}, 'ESC キーイベントを投げる');

key.setCaretKey([['C-n'], ['j']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectLineNext") : goDoCommand("cmd_scrollLineDown");
}, 'キャレットを一行下へ');

key.setCaretKey([['C-p'], ['k']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectLinePrevious") : goDoCommand("cmd_scrollLineUp");
}, 'キャレットを一行上へ');

key.setCaretKey([['C-f'], ['l']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectCharNext") : goDoCommand("cmd_scrollRight");
}, 'キャレットを一文字右へ移動');

key.setCaretKey([['C-b'], ['h'], ['C-h']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectCharPrevious") : goDoCommand("cmd_scrollLeft");
}, 'キャレットを一文字左へ移動');

key.setCaretKey([['C-v'], ['SPC']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectPageNext") : goDoCommand("cmd_movePageDown");
}, 'キャレットを一画面分下へ');

key.setCaretKey('J', function () {
    util.getSelectionController().scrollLine(true);
}, '画面を一行分下へスクロール');

key.setCaretKey('K', function () {
    util.getSelectionController().scrollLine(false);
}, '画面を一行分上へスクロール');

key.setCaretKey(',', function () {
    util.getSelectionController().scrollHorizontal(true);
    goDoCommand("cmd_scrollLeft");
}, '左へスクロール');

key.setCaretKey('.', function () {
    goDoCommand("cmd_scrollRight");
    util.getSelectionController().scrollHorizontal(false);
}, '右へスクロール');

key.setCaretKey('z', function (aEvent) {
    command.recenter(aEvent);
}, 'キャレットの位置までスクロール');

key.setCaretKey([['C-SPC'], ['C-@']], function (aEvent) {
    command.setMark(aEvent);
}, 'マークをセット', true);

key.setCaretKey('R', function () {
    BrowserReload();
}, '更新', true);

key.setCaretKey('B', function () {
    BrowserBack();
}, '戻る');

key.setCaretKey('F', function () {
    BrowserForward();
}, '進む');

key.setCaretKey(['C-x', 'h'], function () {
    goDoCommand("cmd_selectAll");
}, 'すべて選択', true);

key.setCaretKey('f', function () {
    command.focusElement(command.elementsRetrieverTextarea, 0);
}, '最初のインプットエリアへフォーカス', true);
