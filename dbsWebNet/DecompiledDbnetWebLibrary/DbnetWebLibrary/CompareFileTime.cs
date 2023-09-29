// Decompiled with JetBrains decompiler
// Type: DbnetWebLibrary.CompareFileTime
// Assembly: DbnetWebLibrary, Version=1.0.4846.32991, Culture=neutral, PublicKeyToken=null
// MVID: C0BBA738-7D4D-4EF6-BC01-69A3EC828016
// Assembly location: C:\dbnet\SVN_desarrolloDBAX\dbsWebNet\DBNeT.DBAX.Wss\Bin\DbnetWebLibrary.dll

using System.Collections.Generic;
using System.IO;

namespace DbnetWebLibrary
{
  public class CompareFileTime : IComparer<FileInfo>
  {
    public int Compare(FileInfo x, FileInfo y) => x.CreationTime.CompareTo(y.CreationTime);
  }
}
