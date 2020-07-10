

# Contributing to GrowingIO

## 遇到一个BUG?

如果你发现一个bug，你可以帮助我们提交一个issue。甚至你可以提交 Pull Request并修复它，Thanks!

## 功能缺失

如果你发现某些功能缺失，例如缺少对某个框架的支持，你可以：

1. 提交 Feature Request 类型的 issue，这样它将会被讨论，然后我们会评估，考虑是否对其进行添加。
2. 您也可以自行完成该功能的添加，并给我们提交一个 Pull Request，Thank You!

## 如何提交一个issue

当你想提交一个issue时，请注意以下几点：

1. 在提交新问题之前请搜索已打开和已关闭的问题。现有的问题通常包含有关解决方案、解决方案或进度更新的信息。

2. 我们希望尽快修复所有问题，但在修复错误之前，我们需要重现它，所以就需要您提供复现步骤以及额外信息，这样我们才能快速定位一个问题。如果您没有提供相关的信息，并且我们也无从查起，那么我们会关闭这个issue。
3. 推荐通过 [ issue templates ](https://github.com/CaicaiNo/HCPush/issues/new/choose)中选择并填写问题模板来提交一个issue。

通过 [ issue templates ](https://github.com/angular/angular/issues/new/choose) 中对应的模板来提交你的issue，并尽可能的提供详细的问题描述。

## Pull Request(PR)的步骤

进行 PR 之前请参考以下几条原则：

1. 在GitHub中搜索是否有和你的提交相关的PR（你不会想看到，做了半天后结果发现人家已经做过了😌）
2. 确保有一个issue描述了你正在修复的问题，或者记录了你想添加的功能，issue的预先讨论有利于我们接受你的PR请求。
3. 确保你遵循了 Apache 2.0 协议，我们不接受不遵循该协议的代码，请在每个代码文件头部，加上协议说明。
4. 你需要大致遵循我们的 [代码规范](https://github.com/CaicaiNo/HCPush/blob/master/DEVELOPERS.md#coderules) 

## PR步骤

OK，了解了上述原则之后，你可以开始Pull Request的流程了：

1. fork我们的仓库，然后git clone下来。
2. 建立一个新的分支branch，在其基础上进行修改，你需要遵循我们的 [代码规范](https://github.com/CaicaiNo/HCPush/blob/master/DEVELOPERS.md#coderules) 

```c
git checkout -b my-fix-branch master
```

3. 添加适当的测试用例
4. git commit需要满足我们的[Commit规范](https://github.com/CaicaiNo/HCPush/blob/master/DEVELOPERS.md#commit)
5. 然后将branch推送到GitHub

```
git push origin my-fix-branch
```

6. 发起一个Pull Request，选择master仓库，提交。

## check失败

在你提交PR的时候，有可能会check失败，我们会建议你修改，你需要做以下几步：

1. 进行必要的更新，将分支 保持与项目同步

2. 提交change到分支branch。

3. 将更改推送到GitHub存储库(这将更新您的Pull请求)。

   您还可以修改初始提交并强制将它们推到分支。	

```c
git rebase master -i
git push origin my-fix-branch -f
```

## PR被合并后

在你的PR被合并后，你可以安全地删除你的branch并从master中拉出变更:

- 删除远程变更

```c
git push origin --delete my-fix-branch
```

- 下拉主分支

```c
git checkout master -f
```

- 删除本地分支

```
git branch -D my-fix-branch
```

- 更新你的master仓库到最新的版本

```
git pull --ff upstream master
```



感谢你的贡献，Thanks 🌹

