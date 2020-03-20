;;; bundles/dict/package.el -*- lexical-binding: t -*-

(pcase lye-use-dict-package
  ('sdcv (package! sdcv :recipe (:repo "manateelazycat/sdcv" :host github)))
  ('ydcv (package! youdao-dictionary))
  ('gdcv (package! google-translate)))
