

* [Commit 规范](#commit)

# <a name="commit">Commit 规范

## angular规范

这里采用已有的 [angular](https://github.com/angular/angular/commits/master?after=196bfa8fae6b7da9df2601a400164e35e45cefd6+34) 的标准规范，你只需要先大概了解其构成，然后通过工具提交即可。

angular 标准规范模型大致如下:

```
# Header：50个字符以内，描述主要变更内容
#
# Body：更详细的说明文本，建议72个字符以内。 需要描述的信息包括:
# * 为什么这个变更是必须的? 它可能是用来修复一个bug，增加一个feature，提升性能、可靠性、稳定性等等
# * 他如何解决这个问题? 具体描述解决问题的步骤
# * 是否存在副作用、风险? 
#
# Footer：如果需要可以添加一个链接到issue地址或者其它文档，或者关闭某个issue。
```

详细规范标准：

- **Commit** message 都包括三个部分：Header，Body 和 Footer。

```
<type>(<scope>): <subject>
// 空一行
<body>
// 空一行
<footer>
```

其中，Header（第一行）是必需的，Body 和 Footer 可以省略。

永远不要在 git commit 上增加 -m <msg> 或 --message=<msg> 参数，而单独写提交信息.

一个不好的例子： git commit -m "Fix login bug"

------

- **Header**

Header 部分只有一行，包括三个字段：**type**（必需）、**scope**（可选）和 **subject**（必需）。

**type** 用于说明 commit 的类别，只允许使用下面 7 个标识。

- **feat** ：新功能（feature）
- **fix：** 修补 bug fix
- **docs**：只有文档的更新
- **style：** 格式变动（不影响代码运行的变动），例如删除空格，回车，分号添加。
- **refactor**：重构（即不是新增功能，也不是修改 bug 的代码变动）
- **test**：增加缺失的测试或者纠正现有的测试
- **chore**：构建过程、辅助工具的变动
- **perf** ：提高性能的代码修改
- **build**：改变了build工具 如 grunt换成了 npm
- **revert** : 撤销上一次的 commit
- **ci**：CI配置文件和脚本的修改（持续集成）

**scope** 用于说明 commit **影响的范围**，比如数据层、控制层、视图层等等，视项目不同而不同。如果 **scope** 包含的模块过多，就可以以 ***** 替代

**subject** 是 commit 目的的**简短描述**，不超过 50 个字符。

- 以动词开头，使用第一人称现在时，比如 change，而不是 changed 或 changes
- 第一个字母大写
- 结尾不加句号

如果 **type** 为 **feat** 和 **fix**，则该 commit 将肯定出现在 Change log 之中。

> 关于 Change log ，我们会创建一个md文件来记录该分支的所有更改

------

- **Body**

**Body** 部分是对本次 commit 的详细描述，可以分成多行。下面是一个范例。

```
fix(language-service): reinstate getExternalFiles() (#37750) //Header
//下面属于Body
`getExternalFiles()` is an API that could optionally be provided by a tsserver plugin
to notify the server of any additional files that should belong to a particular project.

This API was removed in #34260 mainly
due to performance reasons.

However, with the introduction of "solution-style" tsconfig in typescript 3.9,
the Angular extension could no longer reliably detect the owning Project solely
based on the ancestor tsconfig.json. In order to support this use case, we have
to reinstate `getExternalFiles()`.

Fixes angular/vscode-ng-language-service#824  //description

PR Close #37750 //Footer
```

应该说明代码变动的动机，以及与以前行为的对比。

------

- **description**

位于Body和Footer之间的一行描述内容，可以用来添加修复的bug链接

```
fix(language-service): reinstate getExternalFiles() (#37750) //Header
//下面属于Body
`getExternalFiles()` is an API that could optionally be provided by a tsserver plugin
to notify the server of any additional files that should belong to a particular project.

This API was removed in #34260 mainly
due to performance reasons.

However, with the introduction of "solution-style" tsconfig in typescript 3.9,
the Angular extension could no longer reliably detect the owning Project solely
based on the ancestor tsconfig.json. In order to support this use case, we have
to reinstate `getExternalFiles()`.

Fixes angular/vscode-ng-language-service#824  //description

PR Close #37750 //Footer
```

- **Footer**

Footer 部分只用于 **不兼容变动** 和 **关闭 Issue**。

**不兼容变动**：如果当前代码与上一个版本不兼容，则 Footer 部分以BREAKING CHANGE开头，后面是对变动的描述、以及变动理由和迁移方法。

**关闭 Issue**：这次提交解决的**Issue**，Closes #234 或者关闭多个 Closes #123, #245, #992

**不兼容变动** 示例1：

```
BREAKING CHANGE: isolate scope bindings definition has changed and
    the inject option for the directive controller injection was removed.
    
    To migrate the code follow the example below:
    
    Before:
    
    scope: {
      myAttr: 'attribute',
      myBind: 'bind',
      myExpression: 'expression',
      myEval: 'evaluate',
      myAccessor: 'accessor'
    }
    
    After:
    
    scope: {
      myAttr: '@',
      myBind: '@',
      myExpression: '&',
      // myEval - usually not useful, but in cases where the expression is assignable, you can use '='
      myAccessor: '=' // in directive's template change myAccessor() to myAccessor
    }
    
    The removed `inject` wasn't generaly useful for directives so there should be no code using it.
```

这里去掉了注入的 myEval  字段，属于 不兼容变更
**不兼容变动** 示例2：

```
feat($browser): onUrlChange event (popstate/hashchange/polling)

Added new event to $browser:
- forward popstate event if available
- forward hashchange event if popstate not available
- do polling when neither popstate nor hashchange available

Breaks $browser.onHashChange, which was removed (use onUrlChange instead)
```

------

**关闭 Issue** 可以这样使用：

Closes #234 或者关闭多个 Closes #123, #245, #992

**关闭 Issue** 示例1：

```
refactor(core): throw more descriptive error message in case of invalid host element (#35916)  //Header

This commit replaces an assert with more descriptive error message that is thrown in case `<ng-template>` or `<ng-container>` is used as host element for a Component.

Resolves #35240. 

PR Close #35916 //Footer
```

**关闭 Issue** 示例2：

```
fix($compile): couple of unit tests for IE9

Older IEs serialize html uppercased, but IE9 does not...
Would be better to expect case insensitive, unfortunately jasmine does
not allow to user regexps for throw expectations.

Closes #392
Breaks foo.bar api, foo.baz should be used instead
```

https://github.com/angular/angular/commits/master 上可以查看各种修改commit提交示例

- **revert**

还有一种特殊情况，如果当前 commit 用于撤销以前的 commit，则必须以revert:开头，后面跟着被撤销 Commit 的 Header。

```
revert: feat(pencil): 回退当前版本667ec到 sssee2
```

## Commitizen 工具使用

前面我们了解了commit内容构成，使用Commitizen能帮我们快捷的自动生成这些格式。

(`Commitizen`是一个格式化`commit message`的工具。它的安装需要NPM的支持，NPM是Node.js的包管理工具，所以首先安装node.js)

- Commitizen安装：

```
npm install -g commitizen
```

- 安装changelog，生成changelog的工具：

```
npm install -g conventional-changelog conventional-changelog-cli
```

- 检验是否安装成功：

```
npm ls -g -depth=0
```

- 项目根目录下创建空的package.json，然后进入到项目目录，执行以下命令会生成对应的项目信息：

```
npm init --yes
```

- 运行下面命令，使其支持Angular的Commit message格式：

```
commitizen init cz-conventional-changelog --save --save-exact
```

- 进入到项目目录，执行以下命令生成CHANGELOG.md文件：

```
conventional-changelog -p angular -i CHANGELOG.md -s
```


到这步就成功了，以后，凡是用到 **git commit** 命令的时候统一改为 **git cz**,然后就会出现选项，生成符合格式的Commit Message。

> 关于生成的 node_modules 文件夹需要加入git过滤，package.json 会存在github上，后续拉下来会直接有。

## git cz

用 git cz 命令取代 git commit（先使用git add），这时会出现如下选项：

1.选择 type

```
? Select the type of change that you're committing:
  feat:     A new feature
  fix:      A bug fix
  docs:     Documentation only changes
❯ style:    Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
  refactor: A code change that neither fixes a bug nor adds a feature
  perf:     A code change that improves performance
  test:     Adding missing tests or correcting existing tests
```

2.填写 scope （选填，可跳过）

```
? What is the scope of this change (e.g. component or file name): (press enter t
o skip)
```

3.填写subject

```
? Write a short, imperative tense description of the change (max 93 chars):
```

4.填写描述 （选填，可跳过）

```
? Provide a longer description of the change: (press enter to skip)
```

5.是否为**不兼容变动**

```
? Are there any breaking changes? (y/N)
```

6.是否关联 **Issue**

```
? Does this change affect any open issues? (y/N)
```



然后就可以通过 git log -l 5 查看最近5条记录来确认是否格式。



## commitlint检测机制

为了防止git commit提交不符合规范，使用commitlint来检测，不符合要求的commit将无法提交。

参考链接：https://commitlint.js.org/#/guides-local-setup?id=install-commitlint



## 附录

参考 angular 的commit示例 : https://github.com/angular/angular/commits/master
