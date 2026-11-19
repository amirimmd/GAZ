#pragma once
// Minimal ATL string conversion shim for builds without VC ATL/MFC installed.
#include <windows.h>
#include <vector>

class CA2W {
 public:
  LPWSTR m_psz;

  explicit CA2W(const char* s) : m_psz(nullptr) {
    if (!s) {
      buf_.push_back(L'\0');
      m_psz = buf_.data();
      return;
    }
    int n = MultiByteToWideChar(CP_ACP, 0, s, -1, nullptr, 0);
    if (n <= 0) {
      buf_.push_back(L'\0');
      m_psz = buf_.data();
      return;
    }
    buf_.resize(static_cast<size_t>(n));
    MultiByteToWideChar(CP_ACP, 0, s, -1, buf_.data(), n);
    m_psz = buf_.data();
  }

  operator LPWSTR() const { return m_psz; }
  operator LPCWSTR() const { return m_psz; }

 private:
  std::vector<wchar_t> buf_;
};

class CW2A {
 public:
  LPSTR m_psz;

  explicit CW2A(const wchar_t* s) : m_psz(nullptr) {
    if (!s) {
      buf_.push_back('\0');
      m_psz = buf_.data();
      return;
    }
    int n = WideCharToMultiByte(CP_ACP, 0, s, -1, nullptr, 0, nullptr, nullptr);
    if (n <= 0) {
      buf_.push_back('\0');
      m_psz = buf_.data();
      return;
    }
    buf_.resize(static_cast<size_t>(n));
    WideCharToMultiByte(CP_ACP, 0, s, -1, buf_.data(), n, nullptr, nullptr);
    m_psz = buf_.data();
  }

  operator LPSTR() const { return m_psz; }
  operator LPCSTR() const { return m_psz; }

 private:
  std::vector<char> buf_;
};
