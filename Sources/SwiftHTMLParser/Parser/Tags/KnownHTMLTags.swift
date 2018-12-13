//
//  tags.swift
//  HTMLParser
//
//  Created by Reid Nantes on 2018-05-26.
//  Copyright © 2018 Reid Nantes. All rights reserved.
//

import Foundation

struct HTMLTag {
    let name: String
    let isEmpty: Bool

    init(name: String, isEmpty: Bool = false) {
        self.name = name
        self.isEmpty = isEmpty
    }
}

enum HTMLTagID: String {
    case a = "a"
    case abbr = "abbr"
    case address = "address"
    case area = "area"
    case article = "article"
    case aside = "aside"
    case audio = "audio"
    case b = "b"
    case base = "base"
    case bdi = "bdi"
    case bdo = "bdo"
    case blockquote = "blockquote"
    case body = "body"
    case br = "br"
    case button = "button"
    case canvas = "canvas"
    case caption = "caption"
    case cite = "cite"
    case code = "code"
    case col = "col"
    case colgroup = "colgroup"
    case data = "data"
    case datalist = "datalist"
    case dd = "dd"
    case del = "del"
    case details = "details"
    case dfn = "dfn"
    case dialog = "dialog"
    case div = "div"
    case dl = "dl"
    case dt = "dt"
    case element = "Element"
    case em = "em"
    case embed = "embed"
    case fieldset = "fieldset"
    case figcaption = "figcaption"
    case figure = "figure"
    case footer = "footer"
    case form = "form"
    case h1 = "h1"
    case h2 = "h2"
    case h3 = "h3"
    case h4 = "h4"
    case h5 = "h5"
    case h6 = "h6"
    case head = "head"
    case header = "header"
    case hgroup = "hgroup"
    case hr = "hr"
    case html = "html"
    case i = "i"
    case iframe = "iframe"
    case img = "img"
    case input = "input"
    case ins = "ins"
    case kbd = "kbd"
    case label = "label"
    case legend = "legend"
    case li = "li"
    case link = "link"
    case main = "main"
    case map = "map"
    case mark = "mark"
    case mathML = "MathML"
    case math  = "math "
    case menu = "menu"
    case meta = "meta"
    case meter = "meter"
    case nav = "nav"
    case noscript = "noscript"
    case object = "object"
    case ol = "ol"
    case optgroup = "optgroup"
    case option = "option"
    case output = "output"
    case p = "p"
    case param = "param"
    case picture = "picture"
    case pre = "pre"
    case progress = "progress"
    case q = "q"
    case rp = "rp"
    case rt = "rt"
    case ruby = "ruby"
    case s = "s"
    case samp = "samp"
    case script = "script"
    case section = "section"
    case select = "select"
    case slot = "slot"
    case small = "small"
    case source = "source"
    case span = "span"
    case strong = "strong"
    case style = "style"
    case sub = "sub"
    case summary = "summary"
    case sup = "sup"
    case svg = "svg"
    case table = "table"
    case tbody = "tbody"
    case td = "td"
    case template = "template"
    case textarea = "textarea"
    case tfoot = "tfoot"
    case th = "th"
    case thead = "thead"
    case time = "time"
    case title = "title"
    case tr = "tr"
    case track = "track"
    case u = "u"
    case ul = "ul"
    case `var` = "var"
    case video = "video"
    case wbr = "wbr"
}

let htmlTags: [HTMLTagID: HTMLTag] = [
    .a: HTMLTag.init(name: "a"),
    .abbr: HTMLTag.init(name: "abbr"),
    .address: HTMLTag.init(name: "address"),
    .area: HTMLTag.init(name: "area", isEmpty: true),
    .article: HTMLTag.init(name: "article"),
    .aside: HTMLTag.init(name: "aside"),
    .audio: HTMLTag.init(name: "audio"),
    .b: HTMLTag.init(name: "b"),
    .base: HTMLTag.init(name: "base", isEmpty: true),
    .bdi: HTMLTag.init(name: "bdi"),
    .bdo: HTMLTag.init(name: "bdo"),
    .blockquote: HTMLTag.init(name: "blockquote"),
    .body: HTMLTag.init(name: "body"),
    .br: HTMLTag.init(name: "br", isEmpty: true),
    .button: HTMLTag.init(name: "button"),
    .canvas: HTMLTag.init(name: "canvas"),
    .caption: HTMLTag.init(name: "caption"),
    .cite: HTMLTag.init(name: "cite"),
    .code: HTMLTag.init(name: "code"),
    .col: HTMLTag.init(name: "col", isEmpty: true),
    .colgroup: HTMLTag.init(name: "colgroup"),
    .data: HTMLTag.init(name: "data"),
    .datalist: HTMLTag.init(name: "datalist"),
    .dd: HTMLTag.init(name: "dd"),
    .del: HTMLTag.init(name: "del"),
    .details: HTMLTag.init(name: "details"),
    .dfn: HTMLTag.init(name: "dfn"),
    .dialog: HTMLTag.init(name: "dialog"),
    .div: HTMLTag.init(name: "div"),
    .dl: HTMLTag.init(name: "dl"),
    .dt: HTMLTag.init(name: "dt"),
    .element: HTMLTag.init(name: "Element"),
    .em: HTMLTag.init(name: "em"),
    .embed: HTMLTag.init(name: "embed", isEmpty: true),
    .fieldset: HTMLTag.init(name: "fieldset"),
    .figcaption: HTMLTag.init(name: "figcaption"),
    .figure: HTMLTag.init(name: "figure"),
    .footer: HTMLTag.init(name: "footer"),
    .form: HTMLTag.init(name: "form"),
    .h1: HTMLTag.init(name: "h1"),
    .h2: HTMLTag.init(name: "h2"),
    .h3: HTMLTag.init(name: "h3"),
    .h4: HTMLTag.init(name: "h4"),
    .h5: HTMLTag.init(name: "h5"),
    .h6: HTMLTag.init(name: "h6"),
    .head: HTMLTag.init(name: "head"),
    .header: HTMLTag.init(name: "header"),
    .hgroup: HTMLTag.init(name: "hgroup"),
    .hr: HTMLTag.init(name: "hr", isEmpty: true),
    .html: HTMLTag.init(name: "html"),
    .i: HTMLTag.init(name: "i"),
    .iframe: HTMLTag.init(name: "iframe", isEmpty: true),
    .img: HTMLTag.init(name: "img", isEmpty: true),
    .input: HTMLTag.init(name: "input", isEmpty: true),
    .ins: HTMLTag.init(name: "ins"),
    .kbd: HTMLTag.init(name: "kbd"),
    .label: HTMLTag.init(name: "label"),
    .legend: HTMLTag.init(name: "legend"),
    .li: HTMLTag.init(name: "li"),
    .link: HTMLTag.init(name: "link", isEmpty: true),
    .main: HTMLTag.init(name: "main"),
    .map: HTMLTag.init(name: "map"),
    .mark: HTMLTag.init(name: "mark"),
    .mathML: HTMLTag.init(name: "MathML"),
    .math: HTMLTag.init(name: "math "),
    .menu: HTMLTag.init(name: "menu"),
    .meta: HTMLTag.init(name: "meta", isEmpty: true),
    .meter: HTMLTag.init(name: "meter"),
    .nav: HTMLTag.init(name: "nav"),
    .noscript: HTMLTag.init(name: "noscript"),
    .object: HTMLTag.init(name: "object"),
    .ol: HTMLTag.init(name: "ol"),
    .optgroup: HTMLTag.init(name: "optgroup"),
    .option: HTMLTag.init(name: "option"),
    .output: HTMLTag.init(name: "output"),
    .p: HTMLTag.init(name: "p"),
    .param: HTMLTag.init(name: "param", isEmpty: true),
    .picture: HTMLTag.init(name: "picture"),
    .pre: HTMLTag.init(name: "pre"),
    .progress: HTMLTag.init(name: "progress"),
    .q: HTMLTag.init(name: "q"),
    .rp: HTMLTag.init(name: "rp"),
    .rt: HTMLTag.init(name: "rt"),
    .ruby: HTMLTag.init(name: "ruby"),
    .s: HTMLTag.init(name: "s"),
    .samp: HTMLTag.init(name: "samp"),
    .script: HTMLTag.init(name: "script"),
    .section: HTMLTag.init(name: "section"),
    .select: HTMLTag.init(name: "select"),
    .slot: HTMLTag.init(name: "slot"),
    .small: HTMLTag.init(name: "small"),
    .source: HTMLTag.init(name: "source", isEmpty: true),
    .span: HTMLTag.init(name: "span"),
    .strong: HTMLTag.init(name: "strong"),
    .style: HTMLTag.init(name: "style"),
    .sub: HTMLTag.init(name: "sub"),
    .summary: HTMLTag.init(name: "summary"),
    .sup: HTMLTag.init(name: "sup"),
    .svg: HTMLTag.init(name: "svg"),
    .table: HTMLTag.init(name: "table"),
    .tbody: HTMLTag.init(name: "tbody"),
    .td: HTMLTag.init(name: "td"),
    .template: HTMLTag.init(name: "template", isEmpty: true),
    .textarea: HTMLTag.init(name: "textarea"),
    .tfoot: HTMLTag.init(name: "tfoot"),
    .th: HTMLTag.init(name: "th"),
    .thead: HTMLTag.init(name: "thead"),
    .time: HTMLTag.init(name: "time"),
    .title: HTMLTag.init(name: "title"),
    .tr: HTMLTag.init(name: "tr"),
    .track: HTMLTag.init(name: "track", isEmpty: true),
    .u: HTMLTag.init(name: "u"),
    .ul: HTMLTag.init(name: "ul"),
    .var: HTMLTag.init(name: "var"),
    .video: HTMLTag.init(name: "video"),
    .wbr: HTMLTag.init(name: "wbr", isEmpty: true)
]
let selfClosingHTMLTags: [HTMLTagID] = [
    .area,
    .base,
    .br,
    .col,
    .embed,
    .hr,
    .iframe,
    .img,
    .input,
    .link,
    .meta,
    .param,
    .source,
    .template,
    .track,
    .wbr
]

let allHTMLTagNames = [
    "a",
    "abbr",
    "address",
    "area",
    "article",
    "aside",
    "audio",
    "b",
    "base",
    "bdi",
    "bdo",
    "blockquote",
    "body",
    "br",
    "button",
    "canvas",
    "caption",
    "cite",
    "code",
    "col",
    "colgroup",
    "data",
    "datalist",
    "dd",
    "del",
    "details",
    "dfn",
    "dialog",
    "div",
    "dl",
    "dt",
    "em",
    "embed",
    "fieldset",
    "figcaption",
    "figure",
    "footer",
    "form",
    "h1,",
    "h2,",
    "h3,",
    "h4,",
    "h5,",
    "h6",
    "head",
    "header",
    "hgroup",
    "hr",
    "html",
    "i",
    "iframe",
    "img",
    "input",
    "ins",
    "kbd",
    "label",
    "legend",
    "li",
    "link",
    "main",
    "map",
    "mark",
    "MathMLmath",
    "menu",
    "meta",
    "meter",
    "nav",
    "noscript",
    "object",
    "ol",
    "optgroup",
    "option",
    "output",
    "p",
    "param",
    "picture",
    "pre",
    "progress",
    "q",
    "rp",
    "rt",
    "ruby",
    "s",
    "samp",
    "script",
    "section",
    "select",
    "slot",
    "small",
    "source",
    "span",
    "strong",
    "style",
    "sub",
    "summary",
    "sup",
    "SVG",
    "svg",
    "table",
    "tbody",
    "td",
    "template",
    "textarea",
    "tfoot",
    "th",
    "thead",
    "time",
    "title",
    "tr",
    "track",
    "u",
    "ul",
    "var",
    "video",
    "wbr"
]

// elements with no end tag
// reference: https://developer.mozilla.org/en-US/docs/Glossary/Empty_element
let emptyElementTagNames = [
    "area",
    "base",
    "br",
    "col",
    "embed",
    "hr",
    "iframe",
    "img",
    "input",
    "link",
    "meta",
    "param",
    "source",
    "template",
    "track",
    "wbr"
]

let ignoredTags: [String] = [
    "svg",
    "script"
]
