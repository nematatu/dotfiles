local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s("test", {
        t("function "), i(1, "name"), t("()"),
        t({ "", "  " }), i(2, "-- body"),
        t({ "", "end" }),
    }),

    s("zenn", {
        t("## モチベ"),
        t({ "", "" }),
        i(1, ""),
        t({ "", "" }),
        t({ "", "" }),

        t("## 環境"),
        t({ "", "" }),
        i(""),
        t({ "", "" }),
        t({ "", "" }),

        t("## "), i(""),
        t({ "", "" }),
        t({ "", "" }),

        t("## 参考"),

        -- わかりやすいと思った記事
        -- コマンド1撃でZennの執筆を始める  
        -- https://zenn.dev/miyasic/articles/zenn-writing-command
    }),

    s("message", {
        t(":::message"),
        t({ "", "" }),
        i(1, ""),
        t({ "", "" }),
        t(":::")
    }),

    s("message alert", {
        t(":::message alert"),
        t({ "", "" }),
        i(1, ""),
        t({ "", "" }),
        t(":::")
    }),

    s("details", {
        t(":::details "),i(1, "タイトル"),
        t({ "", "" }),
        i(2, ""),
        t({ "", "" }),
        t(":::")
    }),

    s("con", {
        t("console.log("), i(1, ""), t(")"),
    }),
    s("cons", {
        t("console.log("), i(1, ""), t(")"),
    }),
    s("conso", {
        t("console.log("), i(1, ""), t(")"),
    }),
    s("consol", {
        t("console.log("), i(1, ""), t(")"),
    }),
    s("console", {
        t("console.log("), i(1, ""), t(")"),
    }),

    s("written-by-human", {
        t("![]("), t("https://assets.blog.amatatu.com/written-by-human.avif"), t(")"),
    }),
}
