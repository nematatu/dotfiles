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
        t("# はじめに"),
        t({ "", "" }),
        i(1, "この記事で達成できること(gifあると良い)、対象読者など"),
        t({ "", "" }),
        t({ "", "" }),

        t("## 動作環境"),
        t({ "", "" }),
        i("+この記事で必要なモジュールとかあると良い、それぞれの使用用途も"),
        t({ "", "" }),
        t({ "", "" }),

        t("# やり方"),
        t({ "", "" }),
        t({ "", "" }),

        t("## "), i("手順、スクショやgif、サンプルコード多めで"),
        t({ "", "" }),
        t({ "", "" }),

        t("# おわりに"),
        t({ "", "" }),
        t({ "", "" }),

        t("# 参考"),


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
}
