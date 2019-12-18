# 综合补丁更名

使用综合补丁必须对 `_PTS` 和 `_WAK` 更名。依据原始 DSDT 内容选择正确的更名，如：

- `_PTS` to `ZPTS(1,N)`:

  ```Swift
    Method (_PTS, 1, NotSerialized)  /* _PTS: Prepare To Sleep */
    {
  ```

- `_WAK` to `ZWAK(1,N)`:

  ```Swift
    Method (_WAK, 1, NotSerialized)  /* _WAK: Wake */
    {
  ```

- `_PTS` to `ZPTS(1,S)`:

  ```Swift
    Method (_PTS, 1, Serialized)  /* _PTS: Prepare To Sleep */
    {
  ```

- `_WAK` to `ZWAK(1,S)`:

  ```Swift
    Method (_WAK, 1, Serialized)  /* _WAK: Wake */
    {
  ```
