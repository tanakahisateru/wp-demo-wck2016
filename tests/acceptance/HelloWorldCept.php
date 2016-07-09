<?php
/** @noinspection PhpUndefinedVariableInspection */
$I = new AcceptanceTester($scenario);
$I->wantTo('Hello World 投稿が生きているか確認');

$I->expectTo("Hello world が管理画面で公開済みになっている");
$I->amGoingTo("管理画面に入る");
$I->loginAsAdmin();
$I->amOnAdminPage('/edit.php');
$I->see("Hello world!");
$I->click("Hello world!");
$I->see("公開済み");

$I->expectTo("Hello world が実際に公開されている");
$I->amOnPage('/');
$I->see("Hello World!");
$I->click('#post-1 .more-link');
$I->see("WordPress へようこそ。これは最初の投稿です。編集もしくは削除してブログを始めてください !");
