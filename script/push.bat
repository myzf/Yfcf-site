@REM Jpom���֧����Զ�˺ϲ���������

@echo off

cd ../

call git pull github master:master

call git pull gitee master:master

call git pull github master

call git pull gitee master

echo ���͵�

call git push github master

call git push gitee master

echo ����tags
call git push github --tags

call git push gitee --tags
